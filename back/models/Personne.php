<?php

namespace models;

use core\Model;
use Database;

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
     * Retourne le profil Ambassadeur de la personne si elle est enregistrée dans TD_AMBASSADEUR.
     *
     * @return Ambassadeur|null L'instance Ambassadeur complétée ou null.
     */
    public function getAsAmbassadeur(): ?Ambassadeur
    {
        return $this->fetchRole('TD_AMBASSADEUR', Ambassadeur::class);
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
     * Hydrate les propriétés de l'instance courante à partir d'un tableau associatif.
     *
     * Utilise ReflectionProperty pour initialiser les propriétés readonly (y compris
     * celles déclarées dans une classe mère) sans lever d'erreur de portée.
     *
     * @param array<string, mixed> $data Données issues de la base de données ou de la session.
     * @return static L'instance courante hydratée.
     */
    protected function hydrate(array $data): static
    {
        foreach ($data as $key => $value) {
            $prop = property_exists($this, $key) ? $key : strtolower($key);

            if (property_exists($this, $prop) && $value !== null) {
                $reflection = new \ReflectionProperty($this, $prop);
                if (!$reflection->isInitialized($this)) {
                    $reflection->setValue($this, (string) $value);
                }
            }
        }

        return $this;
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