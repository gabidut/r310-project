export class ModuleApi {
    constructor(client, endpoint, customMethods = {}) {
        this.client = client;
        this.endpoint = String(endpoint || '').replace(/^\/+|\/+$/g, '');

        if (customMethods && typeof customMethods === 'object') {
            this.extend(customMethods);
        }
    }

    extend(methods = {}) {
        for (const [key, fn] of Object.entries(methods)) {
            if (typeof fn === 'function') {
                this[key] = fn.bind(this);
            } else {
                this[key] = fn;
            }
        }
        return this;
    }

    get(path = '', params = {}, options = {}) {
        const sub = path ? `/${String(path).replace(/^\/+/, '')}` : '';
        return this.client.get(`${this.endpoint}${sub}`, params, options);
    }

    post(path = '', data = null, options = {}) {
        const sub = path ? `/${String(path).replace(/^\/+/, '')}` : '';
        return this.client.post(`${this.endpoint}${sub}`, data, options);
    }

    put(path = '', data = null, options = {}) {
        const sub = path ? `/${String(path).replace(/^\/+/, '')}` : '';
        return this.client.put(`${this.endpoint}${sub}`, data, options);
    }

    delete(path = '', params = {}, options = {}) {
        const sub = path ? `/${String(path).replace(/^\/+/, '')}` : '';
        return this.client.delete(`${this.endpoint}${sub}`, params, options);
    }

    query(queryIndex, params = {}, options = {}) {
        return this.get(`query/${encodeURIComponent(queryIndex)}`, params, options);
    }
}

export default ModuleApi;
