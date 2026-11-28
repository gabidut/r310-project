<?php

use core\Router;

$GLOBALS['moduleManifests'] = [];

require_once __DIR__ . '/db/Database.php';

spl_autoload_register(function ($class) {
    $normalized = str_replace('\\', '/', $class);

    // namespace
    $directPath = __DIR__ . '/' . $normalized . '.php';
    if (file_exists($directPath)) {
        require_once $directPath;
        return;
    }

    // classes de modules
    // Ex: modules/apprentissage/controllers/MainApprentissageController
    if (preg_match('#^modules/([^/]+)/(controllers|models|resources)/([^/]+)$#', $normalized, $m)) {
        $modulePath = __DIR__ . '/modules/' . strtolower($m[1]) . '/' . $m[2] . '/' . $m[3] . '.php';
        if (file_exists($modulePath)) {
            require_once $modulePath;
            return;
        }
    }

    // dossiers plats
    $shortClass = basename($normalized);
    foreach (['core/', 'db/', 'controllers/', 'models/', 'resources/'] as $dir) {
        $fallback = __DIR__ . '/' . $dir . $shortClass . '.php';
        if (file_exists($fallback)) {
            require_once $fallback;
            return;
        }
    }

    // sous-dossiers de models/
    $modelsDir = __DIR__ . '/models';
    if (is_dir($modelsDir)) {
        foreach (scandir($modelsDir) as $subdir) {
            if ($subdir === '.' || $subdir === '..') {
                continue;
            }
            $subPath = $modelsDir . '/' . $subdir . '/' . $shortClass . '.php';
            if (file_exists($subPath)) {
                require_once $subPath;
                return;
            }
        }
    }

});

function loadModules(Router $router): void
{
    $modulesDir = __DIR__ . '/modules';
    if (!is_dir($modulesDir)) {
        return;
    }

    foreach (scandir($modulesDir) as $entry) {
        if ($entry === '.' || $entry === '..') {
            continue;
        }

        $moduleDir = $modulesDir . '/' . $entry;
        $manifestFile = $moduleDir . '/index.php';

        if (!is_dir($moduleDir) || !file_exists($manifestFile)) {
            continue;
        }

        $manifest = require $manifestFile;
        if (!is_array($manifest)) {
            continue;
        }

        // auto-découverte des contrôleurs/modèles si non listés explicitement
        if (empty($manifest['controllers']) && is_dir($moduleDir . '/controllers')) {
            foreach (glob($moduleDir . '/controllers/*.php') as $file) {
                $manifest['controllers'][] = pathinfo($file, PATHINFO_FILENAME);
            }
        }
        if (empty($manifest['models']) && is_dir($moduleDir . '/models')) {
            foreach (glob($moduleDir . '/models/*.php') as $file) {
                $manifest['models'][] = pathinfo($file, PATHINFO_FILENAME);
            }
        }

        $GLOBALS['moduleManifests'][$entry] = $manifest;

        if (!empty($manifest['routes']) && is_array($manifest['routes'])) {
            foreach ($manifest['routes'] as $routeDef) {
                [$method, $uri, $action] = $routeDef;
                $router->addRoute($uri, $action, $method);
            }
        }
    }
}