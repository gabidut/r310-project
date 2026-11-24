export default class Module {
    /**
     * @type {Route[]}
     */
    routes = [];

    /**
     * @type {string}
     */
    name = "AnonymousModule";

    constructor(name = "AnonymousModule") {
        this.name = name;
    }
}