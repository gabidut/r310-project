<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header("Access-Control-Allow-Credentials: true");
    header("Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, Accept");
}

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$prefix = getenv('ROUTER_PREFIX') !== false ? getenv('ROUTER_PREFIX') : trim(dirname($_SERVER['SCRIPT_NAME'] ?? ''), '/\\');
if ($prefix === '.' || $prefix === '/') {
    $prefix = '';
}

$router = new Router($prefix);
loadModules($router);

$router->route($_SERVER['REQUEST_URI'] ?? '/');
