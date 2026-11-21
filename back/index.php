<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

$router = new Router('php-kit');
loadModules($router);

$router->route($_SERVER['REQUEST_URI'] ?? '/');