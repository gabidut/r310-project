<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

$router = new Router('php-kit');

$router->addRoute('', 'controllers\WelcomeController@show','GET');

$router->route(trim($_SERVER['REQUEST_URI'], '/'));