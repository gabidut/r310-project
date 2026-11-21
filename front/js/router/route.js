/**
 * Represents a route in the application.
 * Each route has a path, a view (component) to render, optional elements to include, and required roles for access control.
 * @class
 * @property {string} path - The URL path for the route.
 * @property {Function|string} view - The view to render for this route. Can be a function returning HTML or a string representing the path to an HTML file.
 * @property {Array<string>} includeElements - Optional array of elements to include in the view.
 * @property {Array<string>} requiredRoles - Optional array of roles required to access this route.
 *
 * @static
 * @property {string} LOCAL_MODULE_PATH_INDICATOR - The indicator for the local module path.
 */
export default class Route {
    static LOCAL_MODULE_PATH_INDICATOR = "{MODULE_PATH}";

    path;
    view;
    includeElements;
    requiredRoles;

    constructor(path, view, includeElements = [], requiredRoles = []) {
        this.path = path;
        this.view = view;
        this.includeElements = includeElements;
        this.requiredRoles = requiredRoles;
    }
}