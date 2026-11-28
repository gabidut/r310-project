import Module from "../module.js";

export default class ModuleStage extends Module {
    constructor() {
        super("StageModule");
        this.routes = [];
        this.defineApi({});
    }
}
