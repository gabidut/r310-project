import Module from "../module.js";

export default class ModuleApprentissage extends Module {
    constructor() {
        super("ApprentissageModule");
        this.routes = [];
        this.defineApi({});
    }
}
