<?php

namespace resources;

use core\Resource;
use models\Personne;

/**
 * Ressource API formatant le profil de l'utilisateur actuellement connecté (route /me).
 *
 * Expose les propriétés publiques de l'instance Personne (en excluant automatiquement
 * les attributs privés/protégés comme le mot de passe et la connexion PDO) ainsi que
 * ses rôles applicatifs.
 *
 * @property Personne $resource
 * @author   Noah Quaghebeur
 * @version  1.0
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
     * @return array<string, mixed> Propriétés publiques de Personne enrichies de la clé 'roles'.
     */
    public function toArray(): array
    {
        return [
            ...get_object_vars($this->resource),
            'roles' => $this->resource->getRoles(),
        ];
    }
}