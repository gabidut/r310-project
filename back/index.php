<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

$router = new Router('r310-project/back');
loadModules($router);

$router->addRoute('', 'controllers\TestController@test', 'GET');

$router->route($_SERVER['REQUEST_URI'] ?? '/');