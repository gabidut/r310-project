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

    /**
     * Hydrate les propriétés de l'instance courante à partir d'un tableau associatif.
     *
     * Utilise ReflectionProperty pour initialiser les propriétés readonly (y compris
     * celles déclarées dans une classe mère) sans lever d'erreur de portée.
     *
     * @param array<string, mixed> $data Données issues de la base de données ou de la session.
     * @return static L'instance courante hydratée.
     */
    protected function hydrate(array $data): static
    {
        foreach ($data as $key => $value) {
            $prop = property_exists($this, $key) ? $key : strtolower($key);

            if (property_exists($this, $prop) && $value !== null) {
                $reflection = new \ReflectionProperty($this, $prop);
                if (!$reflection->isInitialized($this)) {
                    $reflection->setValue($this, (string) $value);
                }
            }
        }

        return $this;
    }
}