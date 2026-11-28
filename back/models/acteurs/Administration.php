<?php

namespace models\acteurs;

/**
 * Modèle représentant un membre du personnel administratif (table TD_ADMINISTRATION).
 *
 * Hérite des informations générales de Personne et ajoute la date d'embauche administrative.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.1
 */
class Administration extends Personne
{
    /** @var string format SQL YYYY-MM-DD */
    public string $ADM_DATE_EMBAUCHE;

    /**
     * Recherche un membre de l'administration par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsAdministration();
    }
}

if (!class_exists('models\Administration', false)) {
    class_alias(Administration::class, 'models\Administration');
}
