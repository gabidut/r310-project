import Module from "../module.js";

export default class ModuleActeurs extends Module {
    constructor() {
        super("ActeursModule");
        this.routes = [];
        this.defineApi({});
    }
}
