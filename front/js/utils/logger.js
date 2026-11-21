/**
* Logger utility to enhance console.log with module-specific colors and labels.
 *
 * @author gabidut (https://github.com/gabidut)
*/

const originalLog = console.log.bind(console);

const moduleColors = new Map();
function determineColorFromSeed(seed) {
    let hash = 0;
    for (let i = 0; i < seed.length; i++) {
        hash = seed.charCodeAt(i) + ((hash << 5) - hash);
    }
    const index = Math.abs(hash) % 360;
    return `hsl(${index}, 70%, 50%)`;
}

function getColorForModule(moduleName) {
    if (moduleName === "core") return "#94a3b8";

    if (!moduleColors.has(moduleName)) {
        const color = determineColorFromSeed(moduleName);
        moduleColors.set(moduleName, color);
    }
    return moduleColors.get(moduleName);
}

function detectModuleFromStack() {
    const stack = new Error().stack;
    if (!stack) return "core";

    const lines = stack.split("\n");

    for (const line of lines) {
        if (line.includes("logger.js") || line.includes("detectModuleFromStack")) {
            continue;
        }

        const moduleMatch = line.match(/\/modules\/([^/:\s?#)]+)/i);
        if (moduleMatch && moduleMatch[1]) {
            return moduleMatch[1];
        }
    }

    return "core";
}

export function installConsoleModuleHandler() {
    const wrappedLog = function (...args) {
        const moduleName = detectModuleFromStack();
        const color = getColorForModule(moduleName);
        const label = moduleName.toUpperCase();

        originalLog(
            `%c[${label}]`,
            `background: ${color}22; color: ${color}; border: 1px solid ${color}55; padding: 1px 6px; border-radius: 4px; font-weight: bold;`,
            ...args
        );
    };

    wrappedLog.forModule = function (moduleName, ...args) {
        const safeName = moduleName || "core";
        const color = getColorForModule(safeName);
        const label = safeName.toUpperCase();

        originalLog(
            `%c[${label}]`,
            `background: ${color}22; color: ${color}; border: 1px solid ${color}55; padding: 1px 6px; border-radius: 4px; font-weight: bold;`,
            ...args
        );
    };

    console.log = wrappedLog;
}