<?php

namespace models;

/**
 * Modèle représentant un enseignant (table TD_ENSEIGNANT).
 *
 * Hérite des informations générales de Personne et ajoute la date d'embauche de l'enseignant.
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 */
class Enseignant extends Personne
{
    /** @var string format SQL YYYY-MM-DD */
    public string $ENS_DATE_EMBAUCHE;
}