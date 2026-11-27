<?php

namespace models\acteurs;

use core\Model;
use Database;
use models\decision\CompteRendu;
use models\decision\Decision;
use models\communication\Evenement;
use models\decision\Participe;
use models\vieetudiante\Sanction;

/**
 * Modèle de base représentant une personne (table TD_PERSONNE).
 *
 * Centralise les attributs civils et d'authentification communs à tous les utilisateurs,
 * l'hydratation dynamique des propriétés (y compris readonly via réflexion) ainsi que
 * la résolution polymorphique vers ses différents sous-rôles métiers.
 *
 * @author  Noah Quaghebeur
 * @version 1.0
 */
class Personne extends Model
{
    public readonly string $PER_ID;
    private readonly string $PER_PASSWORD;
    public readonly string $PER_NOM;
    public readonly string $PER_PRENOM;
    public readonly string $PER_VILLE_NAISSANCE;
    public readonly string $PER_DATE_NAISSANCE;
    public readonly string $PER_MAIL;
    public readonly ?string $PER_TELEPHONE;

    /**
     * Recherche et instancie un sous-rôle métier associé à cette personne.
     *
     * Interroge la table spécialisée correspondante via PER_ID, instancie le modèle
     * enfant demandé et fusionne les propriétés de la personne avec celles du rôle.
     *
     * @template T of Personne
     * @param string          $table      Nom de la table SQL du rôle (ex: 'TD_ETUDIANT').
     * @param class-string<T> $modelClass Nom complet de la classe modèle à instancier.
     * @return T|null L'instance du sous-rôle hydratée, ou null si la personne ne possède pas ce rôle.
     */
    private function fetchRole(String $table,String $modelClass)
    {
        $stmt = $this->db->prepare("SELECT * FROM {$table} WHERE PER_ID = ? LIMIT 1");
        $stmt->execute([$this->PER_ID]);
        $row = $stmt->fetch();

        if ($row === false) {
            return null;
        }

        $roleInstance = new $modelClass();
        $roleInstance->hydrate(get_object_vars($this));
        $roleInstance->hydrate($row);

        return $roleInstance;
    }

    /**
     * Retourne le profil Étudiant de la personne si elle est inscrite dans TD_ETUDIANT.
     *
     * @return Etudiant|null L'instance Etudiant complétée ou null.
     */
    public function getAsStudent(): ?Etudiant
    {
        return $this->fetchRole('TD_ETUDIANT', Etudiant::class);
    }

    /**
     * Retourne le profil Ambassadeur de la personne si elle est enregistrée dans AMBASSADEUR / TD_AMBASSADEUR.
     *
     * @return Ambassadeur|null L'instance Ambassadeur complétée ou null.
     */
    public function getAsAmbassadeur(): ?Ambassadeur
    {
        $role = $this->fetchRole('AMBASSADEUR', Ambassadeur::class);
        if ($role === null) {
            $role = $this->fetchRole('TD_AMBASSADEUR', Ambassadeur::class);
        }
        return $role;
    }

    /**
     * Retourne le profil Enseignant de la personne si elle est enregistrée dans TD_ENSEIGNANT.
     *
     * @return Enseignant|null L'instance Enseignant complétée ou null.
     */
    public function getAsEnseignant(): ?Enseignant
    {
        return $this->fetchRole('TD_ENSEIGNANT', Enseignant::class);
    }

    /**
     * Retourne le profil Représentant d'entreprise de la personne si elle figure dans TD_REPRESENTANT.
     *
     * @return Representant|null L'instance Representant complétée ou null.
     */
    public function getAsResponsable(): ?Representant
    {
        return $this->fetchRole('TD_REPRESENTANT', Representant::class);
    }

    /**
     * Retourne le profil Administration de la personne si elle figure dans TD_ADMINISTRATION.
     *
     * @return Administration|null L'instance Administration complétée ou null.
     */
    public function getAsAdministration(): ?Administration
    {
        return $this->fetchRole('TD_ADMINISTRATION', Administration::class);
    }

    /**
     * Récupère les rôles applicatifs attribués à la personne (tables TD_ROLE / TD_ATTRIBUE).
     *
     * @return array|false Tableau associatif contenant ROL_ID et ROL_LIBELLE, ou false si aucun rôle.
     */
    public function getRoles()
    {
        $stmt = $this->db->prepare('select TD_ROLE.ROL_ID,ROL_LIBELLE from TD_ROLE join TD_ATTRIBUE on TD_ROLE.ROL_ID = TD_ATTRIBUE.ROL_ID join TD_PERSONNE on TD_ATTRIBUE.PER_ID = TD_PERSONNE.PER_ID where TD_PERSONNE.PER_ID=?');
        $stmt->execute([$this->PER_ID]);
        $role = $stmt->fetchAll();

        return $role;
    }

    /**
     * Retourne le hash du mot de passe de l'utilisateur pour la vérification lors du login.
     *
     * @return string Empreinte du mot de passe stockée en base.
     */
    public function getPassword(): string
    {
        return $this->PER_PASSWORD;
    }

    /**
     * Recherche une personne par son identifiant unique (PER_ID).
     *
     * @param string $id
     * @return static|null
     */
    public static function findById(string $id): ?static
    {
        $stmt = Database::getInstance()->prepare('SELECT * FROM TD_PERSONNE WHERE PER_ID = ? LIMIT 1');
        $stmt->execute([$id]);
        $row = $stmt->fetch();

        if ($row === false) {
            return null;
        }

        return (new static())->hydrate($row);
    }

    /**
     * Récupère toutes les personnes enregistrées.
     *
     * @return static[]
     */
    public static function findAll(): array
    {
        $stmt = Database::getInstance()->query('SELECT * FROM TD_PERSONNE');
        $rows = $stmt->fetchAll();

        return array_map(fn($row) => (new static())->hydrate($row), $rows);
    }

    /**
     * Recherche une personne en base de données à partir de son adresse email.
     *
     * @param string $email Adresse email à rechercher.
     * @return static|null L'instance Personne hydratée ou null si aucun compte ne correspond.
     */
    public static function findByEmail(string $email): ?static
    {
        $stmt = Database::getInstance()->prepare('SELECT * FROM TD_PERSONNE WHERE PER_MAIL = ?');
        $stmt->execute([$email]);
        $user = $stmt->fetch();

        if ($user === false) {
            return null;
        }

        return (new static())->hydrate($user);
    }

    /**
     * Récupère les événements créés par cette personne.
     *
     * @return Evenement[]
     */
    public function getEvenements(): array
    {
        return Evenement::getFromPersonne($this);
    }

    /**
     * Récupère les comptes-rendus rédigés par cette personne.
     *
     * @return CompteRendu[]
     */
    public function getComptesRendus(): array
    {
        return CompteRendu::getFromPersonne($this);
    }

    /**
     * Récupère les décisions prises ou initiées par cette personne.
     *
     * @return Decision[]
     */
    public function getDecisions(): array
    {
        return Decision::getFromPersonne($this);
    }

    /**
     * Récupère les sanctions prononcées ou associées à cette personne.
     *
     * @return Sanction[]
     */
    public function getSanctions(): array
    {
        return Sanction::getFromPersonne($this);
    }

    /**
     * Récupère les réunions auxquelles cette personne participe.
     *
     * @return Participe[]
     */
    public function getParticipationsReunions(): array
    {
        return Participe::getFromPersonne($this);
    }

    /**
     * Instancie et hydrate un modèle à partir d'un tableau de données (ex: reconstruction depuis $_SESSION).
     *
     * @param array<string, mixed> $data Tableau associatif des attributs de la personne.
     * @return static Nouvelle instance hydratée.
     */
    public static function fromArray(array $data): static
    {
        return (new static())->hydrate($data);
    }
}

if (!class_exists('models\Personne', false)) {
    class_alias(Personne::class, 'models\Personne');
}
