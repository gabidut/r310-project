<?php

spl_autoload_register(function ($class) {
    $relativePath = str_replace('\\', '/', $class) . '.php';
    if (file_exists(__DIR__ . '/' . $relativePath)) {
        require_once __DIR__ . '/' . $relativePath;
        return;
    }

    $directories = [
        'core/',
        'db/',
        'controllers/',
        'models/',
        'resources/'
    ];

    foreach ($directories as $directory) {
        $filePath = __DIR__ . '/' . $directory . $class . '.php';
        if (file_exists($filePath)) {
            require_once $filePath;
            return;
        }
    }
});