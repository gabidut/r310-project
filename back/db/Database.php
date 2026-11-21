<?php

namespace db;

use Exception;
use PDO;
use PDOException;

/**
 * Connexion unique à la base de données (Singleton PDO) + gestionnaire de migrations SQL.
 * Chaque groupe utilise Database::getInstance()->getPdo() (via Model) au lieu de recréer une connexion.
 */
class Database
{
    /** @var self|null Instance unique partagée sur toute la requête */
    private static ?Database $instance = null;

    /** @var PDO Objet de connexion à la base de données */
    private PDO $pdo;

    /**
     * Charge les variables d'environnement (.env / système) et ouvre la connexion PDO.
     * Privé pour forcer l'utilisation de Database::getInstance().
     */
    private function __construct()
    {
        $host = $_ENV['DB_HOST'] ?? getenv('DB_HOST') ?: '127.0.0.1';
        $port = $_ENV['DB_PORT'] ?? getenv('DB_PORT') ?: '3306';
        $name = $_ENV['DB_NAME'] ?? getenv('DB_NAME') ?: '';
        $user = $_ENV['DB_USER'] ?? getenv('DB_USER') ?: 'root';
        $pass = $_ENV['DB_PASS'] ?? getenv('DB_PASS') ?: '';
        $charset = $_ENV['DB_CHARSET'] ?? 'utf8mb4';

        $dsn = "mysql:host={$host};port={$port};dbname={$name};charset={$charset}";

        // ERRMODE_EXCEPTION : lève une erreur PHP exploitable en cas de souci SQL
        // FETCH_ASSOC : retourne les lignes sous forme de tableaux associatifs ['colonne' => valeur]
        $this->pdo = new PDO($dsn, $user, $pass, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]);
    }

    /**
     * Récupère l'instance unique de Database (la crée au premier appel).
     */
    public static function getInstance(): self
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Retourne l'instance PDO prête pour les requêtes préparées ($pdo->prepare(...)).
     */
    public function getPdo(): PDO
    {
        return $this->pdo;
    }

    /**
     * Crée la table technique `migrations` si elle n'existe pas encore.
     * Elle sert uniquement à mémoriser les fichiers .sql déjà exécutés.
     */
    private function ensureMigrationsTable(): void
    {
        $this->pdo->exec("
            CREATE TABLE IF NOT EXISTS migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                migration VARCHAR(255) NOT NULL UNIQUE,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ");
    }

    /**
     * Exécute les fichiers *.sql triés par nom qui n'ont pas encore été joués.
     *
     * @param string $migrationsDir Dossier contenant les scripts SQL (ex: 001_users.sql, 002_notes.sql)
     * @param bool   $fresh         Si true, supprime toutes les tables avant de rejouer les migrations depuis zéro
     * @return array Liste des noms de fichiers de migration exécutés pendant cet appel
     * @throws Exception Si un fichier SQL échoue pendant l'exécution
     */
    public function migrate(string $migrationsDir = __DIR__ . '/migrations', bool $fresh = false): array
    {
        // Réinitialisation complète de la base (utile en dev pour repartir de zéro)
        if ($fresh) {
            $this->pdo->exec('SET FOREIGN_KEY_CHECKS = 0');
            $tables = $this->pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
            foreach ($tables as $table) {
                $this->pdo->exec("DROP TABLE IF EXISTS `{$table}`");
            }
            $this->pdo->exec('SET FOREIGN_KEY_CHECKS = 1');
        }

        // S'assure que la table de suivi existe avant de comparer
        $this->ensureMigrationsTable();

        // Récupère les migrations déjà appliquées pour ne pas les rejouer
        $applied = $this->pdo->query('SELECT migration FROM migrations')->fetchAll(PDO::FETCH_COLUMN);
        $appliedMap = array_flip($applied);

        // Récupère et trie alphabétiquement les scripts SQL (préfixer par 001_, 002_, etc.)
        $files = glob(rtrim($migrationsDir, '/') . '/*.sql') ?: [];
        sort($files, SORT_STRING);

        $executed = [];

        foreach ($files as $file) {
            $name = basename($file);

            // Déjà exécutée -> on passe au fichier suivant
            if (isset($appliedMap[$name])) {
                continue;
            }

            $sql = trim((string) file_get_contents($file));
            if ($sql === '') {
                continue;
            }

            try {
                // Joue le script SQL puis enregistre son nom dans la table `migrations`
                $this->pdo->exec($sql);
                $stmt = $this->pdo->prepare('INSERT INTO migrations (migration) VALUES (:migration)');
                $stmt->execute(['migration' => $name]);
                $executed[] = $name;
            } catch (PDOException $e) {
                throw new Exception("Échec de la migration '{$name}' : " . $e->getMessage(), 0, $e);
            }
        }

        return $executed;
    }
}