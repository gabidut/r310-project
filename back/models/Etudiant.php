<?php

namespace models;

use core\Model;

/**
 * Modèle représentant un étudiant (table TD_ETUDIANT).
 *
 * Hérite des informations générales de Personne et associe l'étudiant à son groupe pédagogique.
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 */
class Etudiant extends Personne
{
    /** @var string clé étrangère GRP_ID */
    public string $GRP_ID;
}