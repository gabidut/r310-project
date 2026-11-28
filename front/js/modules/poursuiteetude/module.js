import Route from "../../router/route.js";
import Module from "../module.js";

export default class ModulePoursuiteEtude extends Module {
    constructor() {
        super("PoursuiteEtudeModule");
        this.routes = [];
        this.defineApi({});
    }
}
