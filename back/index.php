<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

$router = new Router('r310-project/back');
loadModules($router);

$router->addRoute('auth/login','controllers\AuthController@login','POST');
$router->addRoute('auth/me','controllers\AuthController@me','GET');


$router->route($_SERVER['REQUEST_URI'] ?? '/');