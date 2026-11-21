<?php

namespace core;

use Database;

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