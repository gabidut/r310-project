<?php

namespace core;

/**
 * Classe de base abstraite pour tous les contrôleurs de l'application
 *
 * Fournit l'accès automatique aux gestionnaires de session et de cookies,
 * ainsi qu'un utilitaire de lecture des données entrantes (JSON ou formulaire).
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 * @see SessionManager
 * @see CookieManager
 */
abstract class Controller
{
    protected SessionManager $session;
    protected CookieManager $cookies;

    /**
     * Initialise le contrôleur en récupérant les instances uniques de gestion des sessions et des cookies
     */
    public function __construct()
    {
        $this->session = SessionManager::getInstance();
        $this->cookies = CookieManager::getInstance();
    }

    /**
     * Récupère les données envoyées par le client (JSON brut via fetch ou $_POST)
     */
    protected function getInput(): array
    {
        $raw = file_get_contents('php://input');
        $json = json_decode($raw, true);

        return is_array($json) ? $json : $_POST;
    }
}