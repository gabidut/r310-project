<?php

namespace core;

use Exception;

/**
 * Classe de routage HTTP simple supportant les paramètres dynamiques
 *
 * @author  Noah Quaghebeur
 * @version 1.1
 */
class Router
{
    private $routes = [];²
    private $prefix;

    /**
     * Initialise le routeur avec un préfixe d'URL optionnel (ex: '/api' ou '/mon-projet')
     *
     * @param string $prefix Préfixe de base à ignorer lors de la résolution des routes
     */
    public function __construct(string $prefix = '')
    {
        $this->prefix = trim($prefix, '/');
    }

    /**
     * Enregistre une nouvelle route dans le routeur
     *
     * @param string $uri              Chemin de la route (ex: 'users/{id}')
     * @param string $controllerMethod Contrôleur et méthode cible au format 'Namespace\Controller@methode'
     * @param string $httpMethod       Méthode HTTP autorisée ('ANY', 'GET', 'POST', 'PUT', 'DELETE')
     * @return void
     */
    public function addRoute(string $uri, string $controllerMethod, string $httpMethod = 'ANY')
    {
        $this->routes[] = [
            'method' => strtoupper($httpMethod),
            'uri'    => trim($uri, '/'),
            'action' => $controllerMethod
        ];
    }

    /**
     * Analyse l'URL demandée et exécute l'action du contrôleur correspondant
     *
     * @param string      $url           URL brute de la requête (ex: $_SERVER['REQUEST_URI'])
     * @param string|null $requestMethod Méthode HTTP de la requête (utilise $_SERVER['REQUEST_METHOD'] par défaut)
     * @return mixed
     * @throws Exception Si le format de l'action est invalide ou si le contrôleur/méthode n'existe pas
     */
    public function route(string $url, string $requestMethod = null)
    {
        $requestMethod = strtoupper($requestMethod ?? ($_SERVER['REQUEST_METHOD'] ?? 'GET'));

        $path = parse_url($url, PHP_URL_PATH) ?? '';
        $path = trim($path, '/');

        if ($this->prefix !== '') {
            if ($path === $this->prefix) {
                $path = '';
            } elseif (strpos($path, $this->prefix . '/') === 0) {
                $path = substr($path, strlen($this->prefix) + 1);
            }
        }

        foreach ($this->routes as $route) {
            if ($route['method'] !== 'ANY' && $route['method'] !== $requestMethod) {
                continue;
            }

            $pattern = preg_replace('/(?:\{[a-zA-Z0-9_]+\}|:[a-zA-Z0-9_]+)/', '([^/]+)', $route['uri']);
            $pattern = '#^' . $pattern . '$#';

            if (preg_match($pattern, $path, $matches)) {
                array_shift($matches);

                if (strpos($route['action'], '@') === false) {
                    throw new Exception("Format d'action invalide pour '{$route['action']}'. Attendu : 'Controller@methode'.");
                }


                if (version_compare(PHP_VERSION, '7.1.0', '>=')) {
                    [$controllerName, $methodName] = explode('@', $route['action'], 2);
                } else {
                    list($controllerName, $methodName) = explode('@', $route['action'], 2);
                }

                if (!class_exists($controllerName)) {
                    throw new Exception("Le contrôleur '$controllerName' est introuvable.");
                }

                $controller = new $controllerName();

                if (!method_exists($controller, $methodName)) {
                    throw new Exception("La méthode '$methodName' n'existe pas dans '$controllerName'.");
                }

                return call_user_func_array([$controller, $methodName], $matches);
            }
        }

        Resource::error('Route introuvable', 404);
        return null;
    }
}