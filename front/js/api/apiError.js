export class ApiError extends Error {
    constructor(message, status = 500, data = null, url = '', method = 'GET') {
        super(message);
        this.name = 'ApiError';
        this.status = status;
        this.data = data;
        this.url = url;
        this.method = method;

        this.isClientError = status >= 400 && status < 500;
        this.isServerError = status >= 500;
        this.isNotFound = status === 404;
        this.isUnauthorized = status === 401;
        this.isForbidden = status === 403;
    }

    toString() {
        return `[ApiError ${this.status}] ${this.method} ${this.url} - ${this.message}`;
    }
}

export default ApiError;
