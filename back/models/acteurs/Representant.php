<?php

namespace models\acteurs;

use Database;
use models\apprentissage\Apprenti;
use models\apprentissage\Entreprise;
use models\apprentissage\Stagiaire;

/**
 * Modèle représentant un responsable ou tuteur d'entreprise (table TD_REPRESENTANT).
 *
 * Hérite des informations générales de Personne et lie l'individu à son entreprise d'appartenance.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.1
 */
class Representant extends Personne
{
    /** @var string clé étrangère ENT_ID */
    public string $ENT_ID;

    /**
     * Recherche un représentant par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $personne = Personne::findById($id);
        return $personne?->getAsResponsable();
    }

    /**
     * Récupère la liste des représentants associés à une entreprise.
     *
     * @param Entreprise $source
     * @return static[]
     */
    public static function getFromEntreprise(Entreprise $source): array
    {
        $stmt = Database::getInstance()->prepare('SELECT * FROM TD_REPRESENTANT WHERE ENT_ID = ?');
        $stmt->execute([$source->ENT_ID]);
        $rows = $stmt->fetchAll();

        $list = [];
        foreach ($rows as $row) {
            $p = Personne::findById($row['PER_ID']);
            if ($p) {
                $r = new static();
                $r->hydrate(get_object_vars($p));
                $r->hydrate($row);
                $list[] = $r;
            }
        }

        return $list;
    }

    /**
     * Récupère l'entreprise à laquelle ce représentant appartient.
     *
     * @return Entreprise|null
     */
    public function getEntreprise(): ?Entreprise
    {
        if (!isset($this->ENT_ID)) {
            return null;
        }
        return Entreprise::findById($this->ENT_ID);
    }

    /**
     * Récupère les apprentis suivis par ce représentant (maître d'apprentissage).
     *
     * @return Apprenti[]
     */
    public function getApprentis(): array
    {
        return Apprenti::getFromRepresentant($this);
    }

    /**
     * Récupère les stagiaires suivis par ce représentant (tuteur entreprise).
     *
     * @return Stagiaire[]
     */
    public function getStagiaires(): array
    {
        return Stagiaire::getFromRepresentant($this);
    }
}

if (!class_exists('models\Representant', false)) {
    class_alias(Representant::class, 'models\Representant');
}
