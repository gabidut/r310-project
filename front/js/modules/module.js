import apiHelper from "../api/index.js";

export default class Module {
    routes = [];
    name = "AnonymousModule";
    endpoint = "";
    api = null;

    constructor(name = "AnonymousModule") {
        this.name = name;
        this.endpoint = name.toLowerCase().replace(/module$/, "");
        this.defineApi();
    }

    defineApi(customMethods = {}, endpoint = null) {
        const ep = endpoint || this.endpoint;
        this.api = apiHelper.createModuleApi(ep, customMethods);
        apiHelper.registerModule(ep, this.api);
        return this.api;
    }
}
