import {installConsoleModuleHandler} from "../utils/logger.js";

installConsoleModuleHandler();

class ModuleLoader {
    constructor() {
        this.modules = [];
    }

    async loadModule(modulePath) {
        const resolvedModuleUrl = new URL(modulePath, import.meta.url);
        const mod = await import(resolvedModuleUrl.href);
        const basePath = resolvedModuleUrl.href.replace(/\/[^/]+$/, "");

        this.modules.push({mod, basePath});
        console.log(`Module loaded: ${resolvedModuleUrl.pathname} (base: ${basePath})`);
        return mod;
    }

    getAllRoutes() {
        const allRoutes = [];

        for (const {mod, basePath} of this.modules) {
            const exportValue = mod.default;
            const instance = typeof exportValue === "function"
                ? new exportValue()
                : exportValue;

            const routes = Array.isArray(instance?.routes)
                ? instance.routes
                : Array.isArray(mod.routes)
                    ? mod.routes
                    : [];

            for (const route of routes) {
                route.modulePath = basePath;
                allRoutes.push(route);
            }
        }

        return allRoutes;
    }
}

const modulesToLoad = [
    "acteurs",
    "apprentissage",
    "decision",
    "docinfo",
    "poursuiteetude",
    "scolarite",
    "stage",
    "vieetudiante",
];

export const moduleLoader = new ModuleLoader();

export const modulesReady = Promise.all(
    modulesToLoad.map((name) =>
        moduleLoader.loadModule(`./${name}/module.js`)
    )
);