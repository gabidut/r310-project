import { ApiClient } from './apiClient.js';
import { ApiError } from './apiError.js';
import { ModuleApi } from './moduleApi.js';

/**
 * ApiHelper : Façade globale et intuitive pour l'ensemble des requêtes de l'application.
 *
 * Fonctionnalités :
 * - Requêtes HTTP directes : apiHelper.get(), apiHelper.post(), etc.
 * - Authentification intégrée : apiHelper.auth.login(), apiHelper.auth.me(), apiHelper.auth.logout()
 * - Gestion modulaire par proxy : apiHelper.acteurs.get(...), apiHelper.vacataires.query(...)
 * - Mode safe : apiHelper.safe(() => apiHelper.get(...))
 */
export class ApiHelper {
    constructor(options = {}) {
        this.client = new ApiClient(options);
        this._modules = new Map();
        this._authListeners = new Set();
        this._currentUser = null;

        // Tente de restaurer l'utilisateur sauvegardé en local
        this._restoreSavedUser();

        // Gestionnaire d'authentification dédié
        this.auth = {
            /**
             * Authentifie un utilisateur avec son email et mot de passe.
             * Enregistre le token de session et récupère le profil de l'utilisateur.
             *
             * @param {string} email
             * @param {string} password
             * @returns {Promise<{ sessionId: string, user: object }>}
             */
            login: async (email, password) => {
                const res = await this.client.post('auth/login', { email, password });
                const sessionId = res?.sessionId || res?.session_id || (typeof res === 'string' ? res : null);

                if (sessionId) {
                    this.client.setAuthToken(sessionId, true);
                }

                // Récupère immédiatement le profil utilisateur
                const user = await this.auth.me();
                this._notifyAuthChange(user);

                return { sessionId, user };
            },

            /**
             * Déconnecte l'utilisateur actuel et supprime les données de session locales.
             *
             * @returns {Promise<boolean>}
             */
            logout: async () => {
                try {
                    await this.client.post('auth/logout');
                } catch {
                    // Même si la requête réseau échoue (ex: déjà déconnecté), on nettoie localement
                } finally {
                    this.client.setAuthToken(null);
                    this._setCurrentUser(null);
                    this._notifyAuthChange(null);
                }
                return true;
            },

            /**
             * Récupère le profil de l'utilisateur actuellement connecté depuis /back/auth/me.
             *
             * @returns {Promise<object|null>}
             */
            me: async () => {
                try {
                    const user = await this.client.get('auth/me');
                    this._setCurrentUser(user);
                    return user;
                } catch (err) {
                    if (err?.status === 401) {
                        this._setCurrentUser(null);
                    }
                    throw err;
                }
            },

            /**
             * Retourne l'utilisateur actuellement en cache mémoire ou localStorage.
             *
             * @returns {object|null}
             */
            getUser: () => {
                return this._currentUser;
            },

            /**
             * Vérifie si un utilisateur semble être connecté (présence d'un token ou profil).
             *
             * @returns {boolean}
             */
            isAuthenticated: () => {
                return Boolean(this.client.getAuthToken() || this._currentUser);
            },

            /**
             * Retourne le token de session actif.
             *
             * @returns {string|null}
             */
            getToken: () => {
                return this.client.getAuthToken();
            },

            /**
             * Définit manuellement un token de session.
             *
             * @param {string|null} token
             */
            setToken: (token) => {
                this.client.setAuthToken(token);
            },

            /**
             * Enregistre un écouteur appelé à chaque connexion ou déconnexion.
             *
             * @param {Function} callback (user|null) => void
             * @returns {Function} fonction de désabonnement
             */
            onAuthChange: (callback) => {
                if (typeof callback === 'function') {
                    this._authListeners.add(callback);
                    // Déclenche immédiatement avec l'état actuel
                    try {
                        callback(this._currentUser);
                    } catch (e) {
                        console.error('Erreur dans auth listener:', e);
                    }
                }
                return () => this._authListeners.delete(callback);
            }
        };

        // Raccourcis directs sur apiHelper
        this.login = this.auth.login.bind(this.auth);
        this.logout = this.auth.logout.bind(this.auth);
        this.me = this.auth.me.bind(this.auth);
        this.getUser = this.auth.getUser.bind(this.auth);
        this.isAuthenticated = this.auth.isAuthenticated.bind(this.auth);
        this.onAuthChange = this.auth.onAuthChange.bind(this.auth);

        // Proxy pour l'accès dynamique aux modules (ex: apiHelper.acteurs)
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

    _setCurrentUser(user) {
        this._currentUser = user;
        if (typeof localStorage !== 'undefined') {
            if (user) {
                localStorage.setItem('r310_auth_user', JSON.stringify(user));
            } else {
                localStorage.removeItem('r310_auth_user');
            }
        }
    }

    _restoreSavedUser() {
        if (typeof localStorage !== 'undefined') {
            try {
                const saved = localStorage.getItem('r310_auth_user');
                if (saved) {
                    this._currentUser = JSON.parse(saved);
                }
            } catch {
                this._currentUser = null;
            }
        }
    }

    _notifyAuthChange(user) {
        for (const listener of this._authListeners) {
            try {
                listener(user);
            } catch (err) {
                console.error('[apiHelper] Erreur dans le listener auth:', err);
            }
        }
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
    window.ApiClient = ApiClient;
}

export {
    ApiClient,
    ApiError,
    ModuleApi
};

export default apiHelper;
