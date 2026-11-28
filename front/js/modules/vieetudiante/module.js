import Module from "../module.js";

export default class ModuleVieEtudiante extends Module {
    constructor() {
        super("VieEtudianteModule");
        this.routes = [];
        this.defineApi({});
    }
}
