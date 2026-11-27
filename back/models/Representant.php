<?php

namespace models;

/**
 * Modèle représentant un responsable ou tuteur d'entreprise (table TD_REPRESENTANT).
 *
 * Hérite des informations générales de Personne et lie l'individu à son entreprise d'appartenance.
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 */
class Representant extends Personne
{
    /** @var string clé étrangère ENT_ID */
    public string $ENT_ID;
}