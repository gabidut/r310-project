import ApiError from './apiError.js';

/**
 * Client HTTP centralisé pour communiquer avec l'API PHP R310.
 * Gère la résolution d'URL, l'authentification (Cookie de session + Header Bearer),
 * la sérialisation JSON, le timeout, les intercepteurs et le formatage des erreurs.
 */
export class ApiClient {
    constructor(options = {}) {
        this.baseUrl = this.resolveBaseUrl(options.baseUrl);
        this.credentials = options.credentials || 'include';
        this.timeout = options.timeout ?? 15000;
        this.debug = Boolean(options.debug);
        this.authToken = null;

        this.headers = {
            'Accept': 'application/json',
            ...(options.headers || {})
        };

        this.interceptors = {
            request: [],
            response: []
        };

        // Restaure un jeton de session sauvegardé s'il existe
        this.restoreSavedToken();
    }

    /**
     * Détermine l'URL de base du backend (/back).
     */
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

    /**
     * Enregistre un token d'authentification (Session ID).
     * Il est automatiquement envoyé dans l'en-tête "Authorization: Bearer <token>"
     * et persisté dans localStorage pour survivre aux rafraîchissements de page.
     */
    setAuthToken(token, persist = true) {
        this.authToken = token ? String(token).trim() : null;

        if (this.authToken) {
            this.setHeader('Authorization', `Bearer ${this.authToken}`);
            if (persist && typeof localStorage !== 'undefined') {
                localStorage.setItem('r310_auth_token', this.authToken);
            }
        } else {
            this.removeHeader('Authorization');
            if (typeof localStorage !== 'undefined') {
                localStorage.removeItem('r310_auth_token');
            }
        }
    }

    getAuthToken() {
        return this.authToken;
    }

    restoreSavedToken() {
        if (typeof localStorage !== 'undefined') {
            const saved = localStorage.getItem('r310_auth_token');
            if (saved) {
                this.setAuthToken(saved, false);
            }
        }
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

    /**
     * Construit une URL absolue ou relative propre, en évitant les doubles préfixes (/back/back/...).
     */
    buildUrl(endpoint, params) {
        let cleanEndpoint = (endpoint || '').trim();
        const queryString = this.buildQueryString(params);

        if (/^https?:\/\//i.test(cleanEndpoint)) {
            return `${cleanEndpoint}${queryString}`;
        }

        // Supprime les slashes de début
        cleanEndpoint = cleanEndpoint.replace(/^\/+/, '');

        const base = (this.baseUrl || '').replace(/\/+$/, '');
        const baseSlug = base.replace(/^\/+/, '');

        // Évite le dédoublement de préfixe si l'appelant a écrit "back/auth/login" ou "/back/auth/login"
        if (baseSlug && cleanEndpoint.startsWith(`${baseSlug}/`)) {
            cleanEndpoint = cleanEndpoint.slice(baseSlug.length + 1);
        } else if (cleanEndpoint === baseSlug) {
            cleanEndpoint = '';
        }

        if (!base) {
            return `/${cleanEndpoint}${queryString}`;
        }

        return cleanEndpoint ? `${base}/${cleanEndpoint}${queryString}` : `${base}${queryString}`;
    }

    /**
     * Exécute une requête HTTP complète avec gestion de timeout, headers et parsing.
     */
    async request(endpoint, options = {}) {
        const method = (options.method || 'GET').toUpperCase();
        const params = options.params;
        const url = this.buildUrl(endpoint, params);

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

        // Si un token d'authentification existe et n'est pas déjà dans les headers, on l'ajoute
        if (this.authToken && !config.headers['Authorization']) {
            config.headers['Authorization'] = `Bearer ${this.authToken}`;
        }

        // Formatage du corps de requête
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

        // Intercepteurs de requête
        for (const interceptor of this.interceptors.request) {
            config = (await interceptor(config)) || config;
        }

        const controller = new AbortController();
        const timeoutMs = options.timeout ?? this.timeout;
        let timeoutId = null;

        if (timeoutMs > 0) {
            timeoutId = setTimeout(() => {
                controller.abort(new Error(`La requête vers ${url} a expiré après ${timeoutMs}ms`));
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

        // Gestion des réponses en erreur (4xx, 5xx)
        if (!rawResponse.ok) {
            let errorMessage = `HTTP ${status}`;

            if (responseData && typeof responseData === 'object') {
                if (responseData.message && typeof responseData.message === 'string') {
                    errorMessage = responseData.message;
                } else if (responseData.error && typeof responseData.error === 'string') {
                    errorMessage = responseData.error;
                } else if (responseData.msg && typeof responseData.msg === 'string') {
                    errorMessage = responseData.msg;
                }
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

        // Dépaquetage automatique de la structure Resource { status, data: ... }
        // Si options.raw est true, on renvoie l'objet brut
        let finalData = responseData;
        if (!options.raw && responseData && typeof responseData === 'object' && 'data' in responseData) {
            finalData = responseData.data;
        }

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

    /**
     * Wrapper sécurisé qui évite le bloc try/catch dans les composants.
     * Retourne toujours un objet { data, error, errorMessage, ok, status }.
     */
    async safe(requestFn) {
        try {
            const data = await requestFn();
            return { data, error: null, errorMessage: null, ok: true, status: 200 };
        } catch (err) {
            const status = err instanceof ApiError ? err.status : 0;
            const errorMessage = err?.message || 'Erreur inattendue';
            return { data: null, error: err, errorMessage, ok: false, status };
        }
    }
}

export default ApiClient;
