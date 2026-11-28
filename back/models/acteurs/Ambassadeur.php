<?php

namespace models\acteurs;

/**
 * Modèle représentant un étudiant ambassadeur (table AMBASSADEUR / TD_AMBASSADEUR).
 *
 * Spécialisation de Personne identifiant les personnes habilitées à représenter la formation.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.1
 */
class Ambassadeur extends Personne
{
    /**
     * Recherche un ambassadeur par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsAmbassadeur();
    }

    /**
     * Récupère les liaisons ambassades de cet ambassadeur.
     *
     * @return Ambassade[]
     */
    public function getAmbassades(): array
    {
        return Ambassade::getFromAmbassadeur($this);
    }

    /**
     * Récupère les questions adressées à cet ambassadeur.
     *
     * @return QuestionAmbassadeur[]
     */
    public function getQuestions(): array
    {
        return QuestionAmbassadeur::getFromAmbassadeur($this);
    }
}

if (!class_exists('models\Ambassadeur', false)) {
    class_alias(Ambassadeur::class, 'models\Ambassadeur');
}
