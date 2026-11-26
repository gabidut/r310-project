import ApiError from './apiError.js';

export class ApiClient {
    constructor(options = {}) {
        this.baseUrl = this.resolveBaseUrl(options.baseUrl);
        this.credentials = options.credentials || 'same-origin';
        this.timeout = options.timeout ?? 15000;
        this.debug = Boolean(options.debug);

        this.headers = {
            'Accept': 'application/json',
            ...(options.headers || {})
        };

        this.interceptors = {
            request: [],
            response: []
        };
    }

    resolveBaseUrl(customBaseUrl) {
        if (typeof customBaseUrl === 'string' && customBaseUrl.trim() !== '') {
            return customBaseUrl.replace(/\/+$/, '');
        }

        if (typeof window !== 'undefined' && window.__API_BASE_URL__) {
            return String(window.__API_BASE_URL__).replace(/\/+$/, '');
        }

        if (typeof document !== 'undefined') {
            const meta = document.querySelector('meta[name="api-base-url"]');
            if (meta?.content) {
                return meta.content.replace(/\/+$/, '');
            }
        }

        if (typeof localStorage !== 'undefined') {
            const saved = localStorage.getItem('api_base_url');
            if (saved) return saved.replace(/\/+$/, '');
        }

        if (typeof window !== 'undefined' && window.location) {
            const { pathname } = window.location;
            if (pathname && pathname.includes('/front')) {
                return pathname.replace(/\/front(\/.*)?$/, '/back');
            }
        }

        return '/back';
    }

    setBaseUrl(url, persist = false) {
        this.baseUrl = (url || '').replace(/\/+$/, '');
        if (persist && typeof localStorage !== 'undefined') {
            localStorage.setItem('api_base_url', this.baseUrl);
        }
    }

    getBaseUrl() {
        return this.baseUrl;
    }

    setCredentials(mode) {
        this.credentials = mode;
    }

    setHeader(name, value) {
        this.headers[name] = value;
    }

    removeHeader(name) {
        delete this.headers[name];
    }

    setDebug(enabled) {
        this.debug = Boolean(enabled);
    }

    addRequestInterceptor(fn) {
        this.interceptors.request.push(fn);
    }

    addResponseInterceptor(onFulfilled, onRejected) {
        this.interceptors.response.push({ onFulfilled, onRejected });
    }

    buildQueryString(params) {
        if (!params || typeof params !== 'object') return '';

        const searchParams = new URLSearchParams();
        for (const [key, val] of Object.entries(params)) {
            if (val === undefined || val === null) continue;
            if (Array.isArray(val)) {
                val.forEach((item) => searchParams.append(`${key}[]`, item));
            } else {
                searchParams.append(key, String(val));
            }
        }

        const query = searchParams.toString();
        return query ? `?${query}` : '';
    }

    buildUrl(endpoint, params) {
        let cleanEndpoint = (endpoint || '').trim();
        const queryString = this.buildQueryString(params);

        if (/^https?:\/\//i.test(cleanEndpoint)) {
            return `${cleanEndpoint}${queryString}`;
        }

        cleanEndpoint = cleanEndpoint.replace(/^\/+/, '');
        const base = this.baseUrl.replace(/\/+$/, '');

        if (!base) {
            return `/${cleanEndpoint}${queryString}`;
        }

        return `${base}/${cleanEndpoint}${queryString}`;
    }

    async request(endpoint, options = {}) {
        const method = (options.method || 'GET').toUpperCase();
        const params = options.params;
        let url = this.buildUrl(endpoint, params);

        let config = {
            method,
            credentials: options.credentials || this.credentials,
            headers: {
                ...this.headers,
                ...(options.headers || {})
            },
            ...options
        };

        delete config.params;

        if (config.body !== undefined && config.body !== null) {
            const isFormData = typeof FormData !== 'undefined' && config.body instanceof FormData;
            const isBlob = typeof Blob !== 'undefined' && config.body instanceof Blob;
            const isURLSearchParams = typeof URLSearchParams !== 'undefined' && config.body instanceof URLSearchParams;

            if (isFormData || isBlob || isURLSearchParams) {
                if (isFormData && config.headers['Content-Type']) {
                    delete config.headers['Content-Type'];
                }
            } else if (typeof config.body === 'object') {
                config.headers['Content-Type'] = config.headers['Content-Type'] || 'application/json; charset=utf-8';
                config.body = JSON.stringify(config.body);
            }
        }

        for (const interceptor of this.interceptors.request) {
            config = (await interceptor(config)) || config;
        }

        const controller = new AbortController();
        const timeoutMs = options.timeout ?? this.timeout;
        let timeoutId = null;

        if (timeoutMs > 0) {
            timeoutId = setTimeout(() => {
                controller.abort(new Error(`Timeout (${timeoutMs}ms)`));
            }, timeoutMs);
        }

        if (options.signal) {
            options.signal.addEventListener('abort', () => controller.abort(options.signal.reason));
        }
        config.signal = controller.signal;

        const startTime = Date.now();
        if (this.debug) {
            console.log(`[apiHelper] -> ${method} ${url}`, config.body || '');
        }

        let rawResponse;
        try {
            rawResponse = await fetch(url, config);
        } catch (fetchErr) {
            if (timeoutId) clearTimeout(timeoutId);
            const isAborted = controller.signal.aborted;
            const message = isAborted
                ? `La requête vers ${url} a expiré après ${timeoutMs}ms`
                : (fetchErr.message || 'Erreur réseau');

            const error = new ApiError(message, 0, null, url, method);

            for (const { onRejected } of this.interceptors.response) {
                if (onRejected) await onRejected(error, config);
            }

            if (this.debug) {
                console.error(`[apiHelper] ! ${method} ${url}`, error);
            }
            throw error;
        } finally {
            if (timeoutId) clearTimeout(timeoutId);
        }

        const duration = Date.now() - startTime;
        const status = rawResponse.status;
        const contentType = rawResponse.headers.get('content-type') || '';

        let responseData = null;
        if (status !== 204) {
            if (contentType.includes('application/json')) {
                try {
                    responseData = await rawResponse.json();
                } catch {
                    responseData = null;
                }
            } else if (options.responseType === 'blob') {
                responseData = await rawResponse.blob();
            } else {
                responseData = await rawResponse.text();
            }
        }

        if (this.debug) {
            const prefix = rawResponse.ok ? '[apiHelper] <-' : '[apiHelper] <!>';
            console.log(`${prefix} [${status}] ${method} ${url} (${duration}ms)`, responseData);
        }

        if (!rawResponse.ok) {
            let errorMessage = `HTTP ${status}`;
            if (responseData && typeof responseData === 'object' && responseData.error) {
                errorMessage = responseData.error;
            } else if (typeof responseData === 'string' && responseData.trim()) {
                errorMessage = responseData;
            } else if (rawResponse.statusText) {
                errorMessage = rawResponse.statusText;
            }

            const error = new ApiError(errorMessage, status, responseData, url, method);

            for (const { onRejected } of this.interceptors.response) {
                if (onRejected) await onRejected(error, config);
            }

            throw error;
        }

        let finalData = responseData;
        for (const { onFulfilled } of this.interceptors.response) {
            if (onFulfilled) {
                finalData = (await onFulfilled(finalData, rawResponse, config)) ?? finalData;
            }
        }

        return finalData;
    }

    get(endpoint, params = {}, options = {}) {
        return this.request(endpoint, { ...options, method: 'GET', params });
    }

    post(endpoint, data = null, options = {}) {
        return this.request(endpoint, { ...options, method: 'POST', body: data });
    }

    put(endpoint, data = null, options = {}) {
        return this.request(endpoint, { ...options, method: 'PUT', body: data });
    }

    patch(endpoint, data = null, options = {}) {
        return this.request(endpoint, { ...options, method: 'PATCH', body: data });
    }

    delete(endpoint, params = {}, options = {}) {
        return this.request(endpoint, { ...options, method: 'DELETE', params });
    }

    async safe(requestFn) {
        try {
            const data = await requestFn();
            return { data, error: null, ok: true, status: 200 };
        } catch (err) {
            const status = err instanceof ApiError ? err.status : 0;
            return { data: null, error: err, ok: false, status };
        }
    }
}

export default ApiClient;
