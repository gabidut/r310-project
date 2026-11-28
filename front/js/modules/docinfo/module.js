import Module from "../module.js";

export default class ModuleDocInfo extends Module {
    constructor() {
        super("DocInfoModule");
        this.routes = [];
        this.defineApi({});
    }
}
