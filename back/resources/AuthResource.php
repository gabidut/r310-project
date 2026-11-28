<?php

namespace resources;

use core\Resource;
use core\SessionManager;
use models\Personne;

/**
 * Ressource API formatant la réponse JSON lors d'une authentification réussie.
 *
 * Encapsule uniquement l'identifiant de session généré côté serveur afin de le
 * transmettre au client sans exposer les données sensibles de l'utilisateur.
 *
 * @property array{session_id: string} $resource
 * @author   Noah Quaghebeur
 * @version  1.0
 */
class AuthResource extends Resource
{
    /**
     * Initialise la ressource d'authentification avec l'identifiant de session PHP.
     *
     * @param string $sessionId Identifiant unique de la session active (issu de session_id()).
     */
    public function __construct(string $sessionId)
    {
        parent::__construct(['session_id' => $sessionId]);
    }

    /**
     * Transforme les données de session en tableau associatif prêt pour la sérialisation JSON.
     *
     * @return array{sessionId: string} Tableau contenant la clé 'sessionId'.
     */
    public function toArray(): array
    {
        return [
            'sessionId' => $this->resource['session_id'],
        ];
    }
}