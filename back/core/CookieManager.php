<?php

namespace core;


use Exception;

/**
 * Classe Singleton de gestion sécurisée des cookies PHP
 *
 * @author  Noah Quaghebeur
 * @version 1.1
 */
class CookieManager
{
    private static $instance = null;

    /**
     * Constructeur privé
     */
    private function __construct()
    {
    }

    /**
     * Verrouille le clonage du Singleton
     */
    public function __clone()
    {
        throw new Exception('Impossible de cloner le gestionnaire de cookies.');
    }

    /**
     * Fournit l'unique instance du CookieManager
     *
     * @return CookieManager
     */
    public static function getInstance(): self
    {
        if (!(self::$instance instanceof self)) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Crée ou met à jour un cookie (supporte chaînes, nombres et tableaux via JSON)
     *
     * @param string $name Nom du cookie
     * @param mixed $value Valeur (si tableau/objet, encodé automatiquement en JSON)
     * @param int $days Durée de vie en jours (30 jours par défaut)
     * @param bool $httpOnly True = inaccessible en JS (sécurité), False = lisible en JS
     */
    public function set(string $name, mixed $value, int $days = 30, bool $httpOnly = true)
    {
        $encodedValue = is_array($value) || is_object($value)
            ? json_encode($value, JSON_UNESCAPED_UNICODE)
            : (string)$value;

        $expires = time() + ($days * 86400);

        setcookie($name, $encodedValue, [
            'expires' => $expires,
            'path' => '/',
            'httponly' => $httpOnly,
            'samesite' => 'Lax'
        ]);

        $_COOKIE[$name] = $encodedValue;
    }

    /**
     * Récupère la valeur d'un cookie (décode automatiquement le JSON si applicable)
     */
    public function get(string $name, mixed $default = null): mixed
    {
        if (!isset($_COOKIE[$name])) {
            return $default;
        }

        $value = $_COOKIE[$name];
        $decoded = json_decode($value, true);

        return (json_last_error() === JSON_ERROR_NONE && is_array($decoded))
            ? $decoded
            : $value;
    }

    /**
     * Vérifie si un cookie existe
     */
    public function has(string $name): bool
    {
        return isset($_COOKIE[$name]);
    }

    /**
     * Supprime un cookie en fixant sa date d'expiration dans le passé
     */
    public function remove(string $name)
    {
        setcookie($name, '', [
            'expires' => time() - 3600,
            'path' => '/',
            'httponly' => true,
            'samesite' => 'Lax'
        ]);

        unset($_COOKIE[$name]);
    }

    /**
     * Retourne tous les cookies actifs
     */
    public function all(): array
    {
        return $_COOKIE ?? [];
    }
}