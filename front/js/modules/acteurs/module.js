import Route from "../../router/route.js";
import Module from "../module.js";

export default class ModuleActeurs extends Module {
    constructor() {
        super("ActeursModule");
        this.routes = [
            new Route("/acteurs", `${Route.LOCAL_MODULE_PATH_INDICATOR}/views/test.html`, ['navbar']),
        ];

        console.log("Module loaded")
    }
}