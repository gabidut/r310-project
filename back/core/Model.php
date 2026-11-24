<?php

namespace core;

use Database;

/**
 * Classe de base abstraite pour tous les modèles de données
 *
 * Centralise l'accès à la connexion PDO unique via la {@code Database}
 * afin d'exécuter les requêtes SQL liées à une table ou un domaine métier.
 *
 * @author  Noah Quaghebeur
 * @version 1.1
 * @see Database
 */
abstract class Model
{
    protected Database $db;

    /**
     * Initialise le modèle en récupérant l'instance unique de la connexion à la base de données
     */
    public function __construct()
    {
        $this->db = Database::getInstance();
    }
}