<?php

require_once __DIR__ . '/autoload.php';

use core\Router;

// Vérification des migrations à chaque requête si DB_AUTO_MIGRATE=true
if (filter_var($_ENV['DB_AUTO_MIGRATE'] ?? getenv('DB_AUTO_MIGRATE') ?? false, FILTER_VALIDATE_BOOLEAN)) {
    Database::checkMigrations();
}

$router = new Router('back');
loadModules($router);

$router->addRoute('','controllers\RootController@index','GET');
$router->addRoute('auth/login','controllers\AuthController@login','POST');
$router->addRoute('auth/me','controllers\AuthController@me','GET');

$router->route($_SERVER['REQUEST_URI'] ?? '/');