<?php

namespace models\acteurs;

/**
 * Modèle représentant un enseignant (table TD_ENSEIGNANT).
 *
 * Hérite des informations générales de Personne et ajoute la date d'embauche de l'enseignant.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.2
 */
class Enseignant extends Personne
{
    /** @var string format SQL YYYY-MM-DD */
    public string $ENS_DATE_EMBAUCHE;

    /**
     * Recherche un enseignant par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsEnseignant();
    }

    /**
     * Convertit l'enseignant en vacataire si possible.
     * La méthode renvoie null si l'enseignant n'est pas vacataire.
     *
     * @return Vacataire|null L'instance de Vacataire si l'enseignant est un vacataire, sinon null.
     */
    public function getAsVacataire(): Vacataire|null
    {
        $stmt = $this->db->prepare("SELECT * FROM TD_VACATAIRE WHERE PER_ID = ? LIMIT 1");
        $stmt->execute([$this->PER_ID]);
        $row = $stmt->fetch();

        if ($row === false) {
            return null;
        }

        $roleInstance = new Vacataire();
        $roleInstance->hydrate(get_object_vars($this));
        $roleInstance->hydrate($row);

        return $roleInstance;
    }

    /**
     * Récupère les matières dont cet enseignant est responsable.
     *
     * @return Matiere[]
     */
    public function getMatieres(): array
    {
        return Matiere::getFromEnseignant($this);
    }

    /**
     * Récupère les enseignements affectés à cet enseignant.
     *
     * @return Enseigner[]
     */
    public function getEnseignements(): array
    {
        return Enseigner::getFromEnseignant($this);
    }

    /**
     * Récupère les jurys d'évaluation auxquels cet enseignant participe.
     *
     * @return Jury[]
     */
    public function getJurys(): array
    {
        return Jury::getFromEnseignant($this);
    }

    /**
     * Récupère les apprentis suivis par cet enseignant (en tant que tuteur pédagogique).
     *
     * @return Apprenti[]
     */
    public function getApprentisTutes(): array
    {
        return Apprenti::getFromEnseignant($this);
    }

    /**
     * Récupère les stagiaires suivis par cet enseignant (en tant que tuteur pédagogique).
     *
     * @return Stagiaire[]
     */
    public function getStagiairesTutes(): array
    {
        return Stagiaire::getFromEnseignant($this);
    }
}

if (!class_exists('models\Enseignant', false)) {
    class_alias(Enseignant::class, 'models\Enseignant');
}
