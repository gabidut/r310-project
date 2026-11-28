<?php

namespace models\vacataires;

use Database;
use models\acteurs\Enseignant;
use models\acteurs\Personne;

/**
 * Modèle représentant un enseignant vacataire (table TD_VACATAIRE).
 *
 * Hérite des informations générales de Enseignant et ajoute le statut professionnel et le taux horaire du vacataire.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.1
 */
class Vacataire extends Enseignant
{
    public ?string $VAC_STATUT_PRO;
    public ?string $VAC_STATUS_PRO;
    public ?string $VAC_TAUX_HORAIRE;

    /**
     * Recherche un vacataire par son identifiant personne (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsEnseignant()?->getAsVacataire();
    }

    /**
     * Récupère la liste des paiements de ce vacataire (table TD_PAIEMENT_VACATAIRE).
     *
     * @return PaiementVacataire[]
     */
    public function getPaiements(): array
    {
        return PaiementVacataire::getFromVacataire($this);
    }

    /**
     * Récupère le dossier administratif de ce vacataire (table TD_DOSSIER_VACATAIRE).
     *
     * @return DossierVacataire|null
     */
    public function getDossier(): ?DossierVacataire
    {
        return DossierVacataire::getFromVacataire($this);
    }

    /**
     * Récupère les étapes de checklist assignées à ce vacataire (table TD_CHECKLIST).
     *
     * @return Checklist[]
     */
    public function getChecklists(): array
    {
        return Checklist::getFromVacataire($this);
    }
}

if (!class_exists('models\Vacataire', false)) {
    class_alias(Vacataire::class, 'models\Vacataire');
}
