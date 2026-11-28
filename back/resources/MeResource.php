<?php

namespace resources;

use core\Resource;
use models\acteurs\Personne;

/**
 * Ressource API formatant le profil de l'utilisateur actuellement connecté (route /me).
 *
 * Expose les propriétés publiques de l'instance Personne (en excluant automatiquement
 * les attributs privés/protégés comme le mot de passe et la connexion PDO) ainsi que
 * ses rôles applicatifs.
 *
 * @property Personne $resource
 * @author   Noah Quaghebeur
 * @version  1.1
 */
class MeResource extends Resource
{
    /**
     * Initialise la ressource avec l'instance de la personne authentifiée.
     *
     * @param Personne $resource Utilisateur reconstruit depuis la session active.
     */
    public function __construct(Personne $resource)
    {
        parent::__construct($resource);
    }

    /**
     * Convertit l'objet Personne et ses rôles en tableau associatif pour la réponse JSON.
     *
     * @return array<string, mixed> Propriétés publiques enrichies d'alias conviviaux et de la liste des rôles.
     */
    public function toArray(): array
    {
        $rawVars = get_object_vars($this->resource);
        $roles = $this->resource->getRoles() ?: [];

        return [
            ...$rawVars,
            'id'        => $this->resource->PER_ID,
            'nom'       => $this->resource->PER_NOM,
            'prenom'    => $this->resource->PER_PRENOM,
            'email'     => $this->resource->PER_MAIL,
            'telephone' => $this->resource->PER_TELEPHONE,
            'roles'     => $roles,
        ];
    }
}
