<?php

namespace models;

/**
 * Modèle représentant un membre du personnel administratif (table TD_ADMINISTRATION).
 *
 * Hérite des informations générales de Personne et ajoute la date d'embauche administrative.
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 */
class Administration extends Personne
{
    /** @var string format SQL YYYY-MM-DD */
    public string $ADM_DATE_EMBAUCHE;
}