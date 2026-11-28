import Module from "../module.js";

export default class ModuleScolarite extends Module {
    constructor() {
        super("ScolariteModule");
        this.routes = [];
        this.defineApi({});
    }
}
