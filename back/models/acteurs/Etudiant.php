<?php

namespace models\acteurs;

use Database;
use models\vieetudiante\Absence;
use models\vieetudiante\Amenagement;
use models\apprentissage\Apprenti;
use models\vieetudiante\Concerner2;
use models\scolarite\Groupe;
use models\vieetudiante\InfoBde;
use models\poursuiteetude\QuestionAmbassadeur;
use models\vieetudiante\RdvSse;
use models\scolarite\Resultat;
use models\poursuiteetude\Souhait;
use models\apprentissage\Stagiaire;

/**
 * Modèle représentant un étudiant (table TD_ETUDIANT).
 *
 * Hérite des informations générales de Personne et associe l'étudiant à son groupe pédagogique.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.1
 */
class Etudiant extends Personne
{
    /** @var string clé étrangère GRP_ID */
    public string $GRP_ID;

    /**
     * Recherche un étudiant par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsStudent();
    }

    /**
     * Récupère la liste des étudiants d'un groupe pédagogique.
     *
     * @param Groupe $source
     * @return static[]
     */
    public static function getFromGroupe(Groupe $source): array
    {
        $stmt = Database::getInstance()->prepare('SELECT * FROM TD_ETUDIANT WHERE GRP_ID = ?');
        $stmt->execute([$source->GRP_ID]);
        $rows = $stmt->fetchAll();

        $list = [];
        foreach ($rows as $row) {
            $p = Personne::findById($row['PER_ID']);
            if ($p) {
                $e = new static();
                $e->hydrate(get_object_vars($p));
                $e->hydrate($row);
                $list[] = $e;
            }
        }

        return $list;
    }

    /**
     * Récupère le groupe pédagogique de cet étudiant.
     *
     * @return Groupe|null
     */
    public function getGroupe(): ?Groupe
    {
        if (!isset($this->GRP_ID)) {
            return null;
        }
        return Groupe::findById($this->GRP_ID);
    }

    /**
     * Récupère les absences de cet étudiant.
     *
     * @return Absence[]
     */
    public function getAbsences(): array
    {
        return Absence::getFromEtudiant($this);
    }

    /**
     * Récupère les aménagements spécifiques de cet étudiant.
     *
     * @return Amenagement[]
     */
    public function getAmenagements(): array
    {
        return Amenagement::getFromEtudiant($this);
    }

    /**
     * Récupère les notes / résultats obtenus par cet étudiant.
     *
     * @return Resultat[]
     */
    public function getResultats(): array
    {
        return Resultat::getFromEtudiant($this);
    }

    /**
     * Récupère le contrat d'apprentissage si l'étudiant est apprenti.
     *
     * @return Apprenti|null
     */
    public function getAsApprenti(): ?Apprenti
    {
        return Apprenti::getFromEtudiant($this);
    }

    /**
     * Récupère la convention de stage si l'étudiant est stagiaire.
     *
     * @return Stagiaire|null
     */
    public function getAsStagiaire(): ?Stagiaire
    {
        return Stagiaire::getFromEtudiant($this);
    }

    /**
     * Récupère les questions posées par cet étudiant aux ambassadeurs.
     *
     * @return QuestionAmbassadeur[]
     */
    public function getQuestionsAmbassadeur(): array
    {
        return QuestionAmbassadeur::getFromEtudiant($this);
    }

    /**
     * Récupère les souhaits de poursuite d'études émis par cet étudiant.
     *
     * @return Souhait[]
     */
    public function getSouhaits(): array
    {
        return Souhait::getFromEtudiant($this);
    }

    /**
     * Récupère les rendez-vous au SSE de cet étudiant.
     *
     * @return RdvSse[]
     */
    public function getRdvs(): array
    {
        return RdvSse::getFromEtudiant($this);
    }

    /**
     * Récupère les sanctions disciplinaires concernant cet étudiant.
     *
     * @return Concerner2[]
     */
    public function getSanctionsConcernes(): array
    {
        return Concerner2::getFromEtudiant($this);
    }

    /**
     * Récupère les publications BDE créées par cet étudiant.
     *
     * @return InfoBde[]
     */
    public function getInfosBde(): array
    {
        return InfoBde::getFromEtudiant($this);
    }
}

if (!class_exists('models\Etudiant', false)) {
    class_alias(Etudiant::class, 'models\Etudiant');
}
