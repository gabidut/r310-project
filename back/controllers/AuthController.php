<?php

namespace controllers;

use core\Controller;
use core\Resource;
use models\acteurs\Personne;
use resources\AuthResource;
use resources\MeResource;

/**
 * Contrôleur gérant l'authentification des utilisateurs et la session courante.
 *
 * Permet la connexion via identifiants (email et mot de passe), l'initialisation
 * de la session utilisateur ainsi que la récupération du profil connecté.
 *
 * @author  Noah Quaghebeur
 * @version 1.3
 */
class AuthController extends Controller
{
    /**
     * Authentifie un utilisateur à partir de son email et de son mot de passe.
     *
     * Vérifie les identifiants reçus en POST (JSON ou formulaire), initialise la session
     * PHP en cas de succès et renvoie l'identifiant de session via AuthResource.
     * Retourne une erreur HTTP 400 si les champs sont manquants ou 401 si invalides.
     *
     * @return void
     */
    public function login(): void
    {
        $data = $this->getInput();

        $email = trim($data['email'] ?? $data['PER_MAIL'] ?? '');
        $password = $data['password'] ?? $data['PER_PASSWORD'] ?? '';

        if ($email === '' || $password === '') {
            Resource::error('Email et mot de passe requis', 400);
            return;
        }

        $user = Personne::findByEmail($email);

        if (!$user || !password_verify($password, $user->getPassword())) {
            Resource::error('Identifiants invalides', 401);
            return;
        }

        $this->session->regenerate();
        $this->session->setMultiple($user);

        (new AuthResource(session_id()))->send(200);
    }

    /**
     * Récupère et renvoie les informations de l'utilisateur actuellement connecté.
     *
     * Reconstruit l'instance Personne depuis la session active et la formate
     * via MeResource. Retourne une erreur HTTP 401 si aucune session valide n'existe.
     *
     * @return void
     */
    public function me(): void
    {
        $user = $this->session->getUser() ?? $this->session->all();

        if (!$user) {
            Resource::error('Non authentifié', 401);
            return;
        }

        (new MeResource($user))->send(200);
    }

    /**
     * Déconnecte l'utilisateur en détruisant sa session active.
     *
     * @return void
     */
    public function logout(): void
    {
        $this->session->destroy();

        (new class(['message' => 'Déconnexion réussie']) extends Resource {
            public function toArray(): array
            {
                return $this->resource;
            }
        })->send(200);
    }
}
