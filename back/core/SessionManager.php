<?php

namespace core;

use Exception;
use models\Personne;

/**
 * Classe Singleton de gestion des sessions PHP
 *
 * @author  Noah Quaghebeur
 * @version 1.3
 */
class SessionManager
{
    private static ?self $instance = null;

    /**
     * Constructeur défini en privé créant ou reprenant une session PHP.
     *
     * Configure les paramètres de sécurité du cookie de session et reprend
     * une session existante si un identifiant est transmis via le header
     * HTTP "Authorization: Bearer <sessionId>".
     */
    private function __construct()
    {
        if (session_status() === PHP_SESSION_NONE) {
            $headers = function_exists('getallheaders') ? getallheaders() : [];
            $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
            if (preg_match('/^Bearer\s+(\S+)$/', $authHeader, $matches)) {
                session_id($matches[1]);
            }

            session_set_cookie_params([
                'lifetime' => 0,
                'path' => '/',
                'httponly' => true,
                'samesite' => 'Lax'
            ]);
            session_start();
        }
    }

    /**
     * Empêche le clonage de l'instance Singleton.
     *
     * @throws Exception Toujours levée pour garantir l'unicité de l'instance.
     */
    public function __clone()
    {
        throw new Exception('Impossible de cloner le gestionnaire de session.');
    }

    /**
     * Fournit l'unique instance du SessionManager.
     *
     * @return self L'instance active du gestionnaire de session.
     */
    public static function getInstance(): self
    {
        if (!(self::$instance instanceof self)) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Régénère l'identifiant de session et enregistre l'objet Personne dans $_SESSION['user'].
     *
     * @param Personne $user L'utilisateur authentifié à stocker.
     * @return void
     */
    public function setUser(Personne $user): void
    {
        $this->regenerate();
        $_SESSION['user'] = $user;
    }

    /**
     * Récupère l'instance Personne stockée directement dans $_SESSION['user'].
     *
     * @return Personne|null L'utilisateur connecté ou null s'il est absent/invalide.
     */
    public function getUser(): ?Personne
    {
        $user = $_SESSION['user'] ?? null;
        if ($user instanceof Personne) {
            return $user;
        }
        return is_array($user) ? Personne::fromArray($user) : null;
    }

    /**
     * Vérifie si un objet Personne valide est actuellement authentifié en session.
     *
     * @return bool True si authentifié, false sinon.
     */
    public function isAuthenticated(): bool
    {
        return $this->getUser() !== null;
    }

    /**
     * Enregistre ou met à jour une valeur à la racine de $_SESSION.
     *
     * @param string $key   Clé de session.
     * @param mixed  $value Valeur à enregistrer.
     * @return void
     */
    public function set(string $key, mixed $value): void
    {
        $_SESSION[$key] = $value;
    }

    /**
     * Enregistre toutes les propriétés publiques d'une instance Personne dans $_SESSION['user'].
     *
     * @param Personne $data L'instance Personne dont les attributs publics seront extraits.
     * @return void
     */
    public function setMultiple(Personne $data): void
    {
        foreach (get_object_vars($data) as $key => $value) {
            $_SESSION['user'][$key] = $value;
        }
    }

    /**
     * Récupère une valeur spécifique dans $_SESSION['user'].
     *
     * @param string $key     Nom de l'attribut recherché.
     * @param mixed  $default Valeur retournée par défaut si la clé n'existe pas.
     * @return mixed La valeur associée ou $default.
     */
    public function get(string $key, mixed $default = null): mixed
    {
        return $_SESSION['user'][$key] ?? $default;
    }

    /**
     * Vérifie si une clé existe dans $_SESSION['user'].
     *
     * @param string $key Nom de l'attribut à vérifier.
     * @return bool True si la clé est définie, false sinon.
     */
    public function has(string $key): bool
    {
        return isset($_SESSION['user'][$key]);
    }

    /**
     * Supprime une clé spécifique dans $_SESSION['user'].
     *
     * @param string $key Nom de l'attribut à supprimer.
     * @return void
     */
    public function remove(string $key): void
    {
        unset($_SESSION['user'][$key]);
    }

    /**
     * Reconstruit et retourne l'instance Personne à partir du tableau $_SESSION['user'].
     *
     * @return Personne|null L'objet Personne hydraté ou null si aucune donnée utilisateur n'existe.
     */
    public function all(): ?Personne
    {
        return $this->getUser();
    }

    /**
     * Retourne l'identifiant de la session PHP active.
     *
     * @return string L'ID de session courant.
     */
    public function getId(): string
    {
        return session_id();
    }

    /**
     * Régénère l'ID de session tout en supprimant l'ancien fichier de session.
     *
     * @return void
     */
    public function regenerate(): void
    {
        session_regenerate_id(true);
    }

    /**
     * Gère les messages flash (lecture unique).
     *
     * Écrit un message si $value est fourni ; sinon lit et supprime
     * immédiatement le message associé à $key.
     *
     * @param string $key   Identifiant du message flash.
     * @param mixed  $value Contenu du message à enregistrer (null pour lire).
     * @return mixed Le message enregistré lors d'une lecture, ou null lors d'une écriture.
     */
    public function flash(string $key, mixed $value = null): mixed
    {
        if ($value !== null) {
            $_SESSION['_flash'][$key] = $value;
            return null;
        }

        $message = $_SESSION['_flash'][$key] ?? null;
        unset($_SESSION['_flash'][$key]);
        return $message;
    }

    /**
     * Vide les données de session, expire le cookie associé et détruit la session serveur.
     *
     * @return void
     */
    public function destroy(): void
    {
        $_SESSION = [];

        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                time() - 42000,
                $params['path'],
                $params['domain'],
                $params['secure'],
                $params['httponly']
            );
        }

        session_destroy();
        self::$instance = null;
    }

    /**
     * Méthode magique permettant d'écrire une donnée à la racine de la session ($session->cle = $val).
     *
     * @param string $key   Clé de session.
     * @param mixed  $value Valeur à assigner.
     * @return void
     */
    public function __set(string $key, mixed $value): void
    {
        $this->set($key, $value);
    }

    /**
     * Méthode magique permettant de lire une propriété de $_SESSION['user'] ($session->cle).
     *
     * @param string $key Nom de l'attribut recherché.
     * @return mixed Valeur associée ou null.
     */
    public function __get(string $key): mixed
    {
        return $this->get($key);
    }

    /**
     * Méthode magique vérifiant l'existence d'une clé dans $_SESSION['user'] (isset($session->cle)).
     *
     * @param string $key Nom de l'attribut à vérifier.
     * @return bool True si défini, false sinon.
     */
    public function __isset(string $key): bool
    {
        return $this->has($key);
    }

    /**
     * Méthode magique supprimant une clé dans $_SESSION['user'] (unset($session->cle)).
     *
     * @param string $key Nom de l'attribut à supprimer.
     * @return void
     */
    public function __unset(string $key): void
    {
        $this->remove($key);
    }
}