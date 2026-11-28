import Route from "./route.js";
import {moduleLoader, modulesReady} from "../modules/module_loader.js";

const app = document.getElementById("app");
const ROOT_PATH = new URL("../../", import.meta.url).pathname.replace(/\/$/, "");

document.addEventListener("DOMContentLoaded", async () => {
    await modulesReady;

    const router = new Router();
    window.router = router;

    router.addRoute(new Route("/", "./views/main.html", ["navbar"]));
    router.addRoute(new Route("/login", "./views/login.html", ["navbar"]));

    for (const route of moduleLoader.getAllRoutes()) {
        router.addRoute(route);
    }

    await router.setupEventListeners();
});
class Router {
    /**
     * @type {Route[]}
     */
    routes = [];

    constructor() {}


    /**
     * Add a new route to the router.
     * @param {Route} route - The route to add.
     */
    addRoute(route) {
        console.log(`Adding route: ${route.path} with view: ${route.view}`);
        this.routes.push(route);
    }

    pathToRegex(path) {
        const paramNames = [];
        const regexPath = path
            .replace(/\//g, "\\/")
            .replace(/:(\w+)/g, (_, paramName) => {
                paramNames.push(paramName);
                return "([^\\/]+)";
            });

        return {
            regex: new RegExp(`^${regexPath}$`),
            paramNames,
        };
    }

    resolveViewPath(view, modulePath = "") {
        if (typeof view !== "string") return view;
        return view.replaceAll(Route.LOCAL_MODULE_PATH_INDICATOR, modulePath);
    }

    resolveComponentUrl(elementToInclude) {
        const fileName = elementToInclude.endsWith(".html")
            ? elementToInclude
            : `${elementToInclude}.html`;

        return `${ROOT_PATH}/components/${fileName}`.replace(/\/+/g, "/");
    }

    getTargetContainer(position) {
        if (!position) return null;

        let target =
            document.querySelector(`[data-position="${position}"]`) ||
            document.getElementById(position);

        if (target) return target;

        if (position === "navbar") {
            target = document.querySelector("nav") || document.createElement("nav");
            target.dataset.position = "navbar";
            if (!target.parentElement) document.body.prepend(target);
            return target;
        }

        if (position === "footer") {
            target = document.querySelector("footer") || document.createElement("footer");
            target.dataset.position = "footer";
            if (!target.parentElement) document.body.append(target);
            return target;
        }

        target = document.createElement("div");
        target.dataset.position = position;
        document.body.prepend(target);
        return target;
    }

    async loadIncludes(includeElements = []) {
        if (!Array.isArray(includeElements) || includeElements.length === 0) {
            return;
        }

        await Promise.all(
            includeElements.map(async (elementToInclude) => {
                const url = this.resolveComponentUrl(elementToInclude);

                try {
                    const response = await fetch(url);
                    if (!response.ok) {
                        throw new Error(`HTTP ${response.status}`);
                    }

                    const html = await response.text();
                    const doc = new DOMParser().parseFromString(html, "text/html");

                    const metaEl = doc.querySelector("meta[position], meta[name='position']");
                    const position =
                        metaEl?.getAttribute("position") ||
                        metaEl?.getAttribute("content") ||
                        elementToInclude;

                    const bodyContent = doc.body ? doc.body.innerHTML : html;
                    const container = this.getTargetContainer(position);

                    if (container) {
                        container.innerHTML = bodyContent;
                    }
                } catch (error) {
                    console.error(
                        `Failed to include component "${elementToInclude}" from ${url}:`,
                        error
                    );
                }
            })
        );
    }

    async router() {
        const currentPath = window.location.pathname;

        console.log(`Routing to: ${currentPath}`);

        for (const route of this.routes) {
            console.log(`Checking route: ${route.path} against current path: ${currentPath}`);
            const { regex, paramNames } = this.pathToRegex(route.path);
            const match = currentPath.match(regex);

            if (match) {
                await this.loadIncludes(route.includeElements);

                const params = {};
                paramNames.forEach((name, index) => {
                    params[name] = decodeURIComponent(match[index + 1]);
                });

                if (typeof route.view === "function") {
                    app.innerHTML = route.view(params);
                } else if (typeof route.view === "string") {
                    const viewUrl = this.resolveViewPath(route.view, route.modulePath);
                    const response = await fetch(viewUrl);
                    const html = await response.text();
                    const doc = new DOMParser().parseFromString(html, "text/html");

                    if (!doc.body || !doc.body.innerHTML) {
                        console.error(`Failed to load view from ${viewUrl}`);
                        app.innerHTML = await this.notFoundView();
                        return;
                    }

                    app.innerHTML = doc.body.innerHTML;
                    app.querySelectorAll("script").forEach((oldScript) => {
                        const newScript = document.createElement("script");
                        Array.from(oldScript.attributes).forEach((attr) => newScript.setAttribute(attr.name, attr.value));
                        newScript.textContent = oldScript.textContent;
                        oldScript.replaceWith(newScript);
                    });
                }
                return;
            }
        }

        app.innerHTML = await this.notFoundView();
    }

    async navigateTo(url) {
        history.pushState(null, null, url);
        await this.router();
    }

    async setupEventListeners() {
        document.body.addEventListener("click", async (e) => {
            const link = e.target.closest("[data-link]");
            if (link) {
                e.preventDefault();
                await this.navigateTo(link.getAttribute("href"));
            }
        });

        await this.router();
        window.addEventListener("popstate", () => this.router());
    }

    async notFoundView() {
        const route = this.routes.find((r) => r.path === "/404");
        if (route) {
            if (typeof route.view === "function") {
                return route.view();
            }
            if (typeof route.view === "string") {
                const viewUrl = this.resolveViewPath(route.view, route.modulePath);
                const response = await fetch(viewUrl);
                const html = await response.text();
                const doc = new DOMParser().parseFromString(html, "text/html");
                return doc.body?.innerHTML || html;
            }
        }
        return `<h1>404</h1><p>Page not found.</p>`;
    }
}