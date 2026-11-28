import Module from "../module.js";

export default class ModuleDecision extends Module {
    constructor() {
        super("DecisionModule");
        this.routes = [];
        this.defineApi({});
    }
}
