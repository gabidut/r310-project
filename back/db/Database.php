<?php

$envPath = __DIR__ . '/../.env';

if (file_exists($envPath)) {
    $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) {
            continue;
        }
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value, " \t\n\r\0\x0B\"'");

        $_ENV[$name] = $value;
        putenv("$name=$value");
    }
}

/**
 * Classe Singleton de connexion à un serveur MySQL
 *
 * Gère la connexion PDO unique, les transactions et l'application
 * performante des migrations de schéma avec vérification optimisée par cache.
 *
 * @author  Noah Quaghebeur
 * @author  gabidut
 * @version 1.3
 */
class Database
{
    private static $PDO = NULL;
    private static $Instance = NULL;
    private static bool $migrationsChecked = false;
    private static string $cacheFile = __DIR__ . '/.migrations_cache';

    /**
     * Constructeur défini en privé créant une connexion MySQL
     */
    private function __construct()
    {
        if (empty($_ENV['DB_HOST']) || empty($_ENV['DB_NAME'])) {
            return;
        }

        $dsn = sprintf(
            'mysql:host=%s;port=%s;dbname=%s;charset=%s',
            $_ENV['DB_HOST'],
            $_ENV['DB_PORT'],
            $_ENV['DB_NAME'],
            $_ENV['DB_CHARSET']
        );

        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        if (defined('PDO::MYSQL_ATTR_MULTI_STATEMENTS')) {
            $options[PDO::MYSQL_ATTR_MULTI_STATEMENTS] = true;
        }

        self::$PDO = new PDO($dsn, $_ENV['DB_USER'], $_ENV['DB_PASS'], $options);
    }

    /**
     * Méthode de destruction de l'instance Database
     */
    public function __destruct()
    {
        self::$PDO = null;
    }

    /**
     * Méthode clone verrouillée via une exception
     * @throws Exception
     */
    public function __clone()
    {
        throw new Exception('Impossible de cloner une connexion SQL');
    }

    /**
     * Méthode pour l'appel des fonctions de l'objet PDO quand
     * elles ne sont pas définies dans la classe
     *
     * @param string $method méthode de l'objet {@code PDO}
     * @param array  $params paramètres de la méthode
     */
    public function __call($method, $params)
    {
        if (self::$PDO === NULL) {
            $this->__construct();
        }

        if (self::$PDO === NULL) {
            throw new Exception("Impossible d'exécuter '$method' : la base de données n'est pas configurée (.env manquant ou incomplet).");
        }

        return call_user_func_array([self::$PDO, $method], $params);
    }

    /**
     * Fournit l'unique instance de {@code Database}
     *
     * @return Database instance unique
     */
    public static function getInstance(): static
    {
        if (!(self::$Instance instanceof self)) {
            self::$Instance = new self();
        }
        return self::$Instance;
    }

    /**
     * Exécute un ensemble d'opérations dans une transaction SQL sécurisée
     *
     * @param callable $callback Fonction recevant l'instance Database en paramètre
     * @return mixed La valeur de retour du callback
     * @throws Throwable En cas d'erreur, annule la transaction et relance l'exception
     */
    public function transaction(callable $callback)
    {
        if (self::$PDO === null) {
            $this->__construct();
        }

        self::$PDO->beginTransaction();

        try {
            $result = $callback($this);
            self::$PDO->commit();
            return $result;
        } catch (\Throwable $e) {
            if (self::$PDO->inTransaction()) {
                self::$PDO->rollBack();
            }
            throw $e;
        }
    }

    /**
     * Crée la table technique `migrations` si elle n'existe pas encore.
     * Utilise CREATE TABLE IF NOT EXISTS pour éviter une requête SHOW TABLES superflue.
     */
    private function ensureMigrationsTable(): void
    {
        self::$PDO->exec("
            CREATE TABLE IF NOT EXISTS migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                filename VARCHAR(255) NOT NULL UNIQUE,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB;
        ");
    }

    /**
     * Détecte le nom de la colonne utilisée pour stocker le nom du fichier.
     * Assure la compatibilité entre 'filename' et 'migration'.
     */
    private function getMigrationColumnName(): string
    {
        try {
            $stmt = self::$PDO->query("SHOW COLUMNS FROM migrations LIKE 'migration'");
            if ($stmt && $stmt->fetch()) {
                return 'migration';
            }
        } catch (\Throwable $e) {
            // En cas d'erreur, utiliser le nom standard
        }
        return 'filename';
    }

    /**
     * Enregistre l'état des migrations dans un fichier de cache local.
     *
     * @param string $migrationsDir
     * @param array  $files
     */
    private function updateMigrationCache(string $migrationsDir, array $files): void
    {
        try {
            $maxMtime = is_dir($migrationsDir) ? filemtime($migrationsDir) : time();
            foreach ($files as $f) {
                if (file_exists($f)) {
                    $maxMtime = max($maxMtime, filemtime($f));
                }
            }

            $data = [
                'updated_at' => time(),
                'max_mtime'  => $maxMtime,
                'files'      => array_map('basename', $files),
            ];

            file_put_contents(self::$cacheFile, json_encode($data, JSON_PRETTY_PRINT));
            @touch(self::$cacheFile, max(time(), $maxMtime));
        } catch (\Throwable $e) {
            // Ignorer silencieusement si droits insuffisants
        }
    }

    /**
     * Vérifie rapidement si des migrations doivent être appliquées.
     * Grâce au cache de signature, cette méthode n'effectue AUCUNE requête SQL
     * ni connexion inutile lorsque les migrations sont déjà à jour.
     *
     * @param string $migrationsDir
     * @return bool True si des migrations ont été exécutées, False si le cache était valide.
     */
    public static function checkMigrations(string $migrationsDir = __DIR__ . '/migrations'): bool
    {
        if (self::$migrationsChecked) {
            return false;
        }

        // Possibilité de désactiver la vérification automatique dans le .env
        if (isset($_ENV['DB_AUTO_MIGRATE']) && in_array(strtolower($_ENV['DB_AUTO_MIGRATE']), ['false', '0', 'off', 'no'], true)) {
            self::$migrationsChecked = true;
            return false;
        }

        // Vérification par cache de fichiers : 0 connexion et 0 requête SQL si valide (~0.05 ms)
        if (file_exists(self::$cacheFile) && is_dir($migrationsDir)) {
            $cacheMtime = filemtime(self::$cacheFile);
            $dirMtime = filemtime($migrationsDir);

            if ($dirMtime <= $cacheMtime) {
                self::$migrationsChecked = true;
                return false;
            }
        }

        // Si modification détectée ou premier lancement : on instancie la BDD et applique les migrations
        self::getInstance()->migrate($migrationsDir, false);
        return true;
    }

    /**
     * Exécute les fichiers *.sql triés par nom qui n'ont pas encore été joués.
     *
     * @param string $migrationsDir Dossier contenant les scripts SQL (défaut: __DIR__ . '/migrations')
     * @param bool   $fresh         Si true, supprime toutes les tables avant de rejouer les migrations
     * @return array Liste des noms de fichiers de migration exécutés pendant cet appel
     * @throws Exception lève une Exception si un fichier SQL échoue pendant l'exécution
     */
    public function migrate(string $migrationsDir = __DIR__ . '/migrations', bool $fresh = false): array
    {
        if ($fresh) {
            if (php_sapi_name() === 'cli') {
                echo "[Database] Réinitialisation de la base de données (fresh = true)...\n";
            }
            self::$PDO->exec('SET FOREIGN_KEY_CHECKS = 0');
            $tables = self::$PDO->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
            foreach ($tables as $table) {
                self::$PDO->exec("DROP TABLE IF EXISTS `{$table}`");
            }
            self::$PDO->exec('SET FOREIGN_KEY_CHECKS = 1');

            if (file_exists($this->cacheFile)) {
                @unlink($this->cacheFile);
            }
        }

        $this->ensureMigrationsTable();

        $col = $this->getMigrationColumnName();
        $applied = self::$PDO->query("SELECT {$col} FROM migrations")->fetchAll(PDO::FETCH_COLUMN);
        $appliedMap = array_flip($applied);

        $files = glob(rtrim($migrationsDir, '/') . '/*.sql') ?: [];
        sort($files, SORT_STRING);

        $executed = [];

        foreach ($files as $file) {
            $name = basename($file);

            if (isset($appliedMap[$name])) {
                continue;
            }

            $sql = trim((string) file_get_contents($file));
            if ($sql === '') {
                continue;
            }

            try {
                self::$PDO->exec($sql);
                $stmt = self::$PDO->prepare("INSERT INTO migrations ({$col}) VALUES (?)");
                $stmt->execute([$name]);
                $executed[] = $name;

                if (php_sapi_name() === 'cli') {
                    echo "[Database] Migration appliquée : {$name}\n";
                }
            } catch (PDOException $e) {
                throw new Exception("Échec de la migration '{$name}' : " . $e->getMessage(), 0, $e);
            }
        }

        // Mise à jour de la signature de cache pour les futures requêtes
        $this->updateMigrationCache($migrationsDir, $files);
        self::$migrationsChecked = true;

        return $executed;
    }

    /**
     * Retourne l'état de chaque migration (appliquée ou en attente).
     *
     * @param string $migrationsDir
     * @return array<array{filename: string, applied: bool, executed_at: ?string}>
     */
    public function getMigrationStatus(string $migrationsDir = __DIR__ . '/migrations'): array
    {
        $this->ensureMigrationsTable();
        $col = $this->getMigrationColumnName();

        $stmt = self::$PDO->query("SELECT {$col} AS filename, executed_at FROM migrations");
        $rows = $stmt->fetchAll();
        $appliedMap = [];
        foreach ($rows as $r) {
            $appliedMap[$r['filename']] = $r['executed_at'] ?? null;
        }

        $files = glob(rtrim($migrationsDir, '/') . '/*.sql') ?: [];
        sort($files, SORT_STRING);

        $status = [];
        foreach ($files as $file) {
            $name = basename($file);
            $isApplied = isset($appliedMap[$name]);
            $status[] = [
                'filename'    => $name,
                'applied'     => $isApplied,
                'executed_at' => $isApplied ? $appliedMap[$name] : null,
            ];
        }

        return $status;
    }
}
