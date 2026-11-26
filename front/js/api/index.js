import { ApiClient } from './apiClient.js';
import { ApiError } from './apiError.js';
import { ModuleApi } from './moduleApi.js';

export class ApiHelper {
    constructor(options = {}) {
        this.client = new ApiClient(options);
        this._modules = new Map();

        return new Proxy(this, {
            get(target, prop, receiver) {
                if (prop in target || typeof prop === 'symbol') {
                    return Reflect.get(target, prop, receiver);
                }

                if (target._modules.has(prop)) {
                    return target._modules.get(prop);
                }

                return target.createModuleApi(String(prop));
            }
        });
    }

    request(endpoint, options) {
        return this.client.request(endpoint, options);
    }

    get(endpoint, params, options) {
        return this.client.get(endpoint, params, options);
    }

    post(endpoint, data, options) {
        return this.client.post(endpoint, data, options);
    }

    put(endpoint, data, options) {
        return this.client.put(endpoint, data, options);
    }

    patch(endpoint, data, options) {
        return this.client.patch(endpoint, data, options);
    }

    delete(endpoint, params, options) {
        return this.client.delete(endpoint, params, options);
    }

    safe(requestFn) {
        return this.client.safe(requestFn);
    }

    query(moduleName, queryIndex, params = {}, options = {}) {
        const cleanModule = String(moduleName).replace(/^\/+|\/+$/g, '');
        return this.client.get(`${cleanModule}/query/${encodeURIComponent(queryIndex)}`, params, options);
    }

    all(promises) {
        return Promise.all(promises);
    }

    registerModule(moduleName, apiInstance) {
        const key = String(moduleName).toLowerCase().replace(/module$/, '');
        this._modules.set(key, apiInstance);
        this[key] = apiInstance;
        return apiInstance;
    }

    createModuleApi(moduleName, customMethods = {}) {
        const key = String(moduleName).toLowerCase().replace(/module$/, '');
        if (this._modules.has(key)) {
            const existing = this._modules.get(key);
            if (existing instanceof ModuleApi && customMethods) {
                existing.extend(customMethods);
            }
            return existing;
        }

        const newApi = new ModuleApi(this.client, key, customMethods);
        this._modules.set(key, newApi);
        this[key] = newApi;
        return newApi;
    }

    setBaseUrl(url, persist = false) {
        this.client.setBaseUrl(url, persist);
        return this;
    }

    getBaseUrl() {
        return this.client.getBaseUrl();
    }

    setCredentials(mode) {
        this.client.setCredentials(mode);
        return this;
    }

    setHeader(name, value) {
        this.client.setHeader(name, value);
        return this;
    }

    removeHeader(name) {
        this.client.removeHeader(name);
        return this;
    }

    setDebug(enabled) {
        this.client.setDebug(enabled);
        return this;
    }
}

export const apiHelper = new ApiHelper();

if (typeof window !== 'undefined') {
    window.apiHelper = apiHelper;
    window.ApiError = ApiError;
}

export {
    ApiClient,
    ApiError,
    ModuleApi
};

export default apiHelper;
