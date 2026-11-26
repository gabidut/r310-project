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
 * @author  Noah Quaghebeur
 * @version 1.2
 */
class Database
{
    static private $PDO = NULL;
    static private $Instance = NULL;

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

        self::$PDO = new PDO($dsn, $_ENV['DB_USER'], $_ENV['DB_PASS'], $options);
        $this->migrate();
    }

    /**
     * Methode de destruction de l'instance Database
     */
    public function __destruct() {
        self::$PDO = null ;
    }

    /**
     * Methode clone verrouillée via une exception
     * @throws Exception
     */
    public function __clone() {
        throw new Exception('Impossible de cloner une connexion SQL');
    }


    /**
     * Méthode pour l'appel des fonctions de l'objet PDO quand
     * elles ne sont pas définies dans la classe
     *
     * @param type $method méthode de l'objet {@code PDO}
     * @param type $params paramètre de la méthode
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
    static public function getInstance(){
        if(!(self::$Instance instanceof self)){
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
            self::__construct();
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
     * Elle sert uniquement à mémoriser les fichiers .sql déjà exécutés.
     */
    private function ensureMigrationsTable(): void
    {
        self::$PDO->exec("
            CREATE TABLE IF NOT EXISTS migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                migration VARCHAR(255) NOT NULL UNIQUE,
                applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ");
    }

    /**
     * Exécute les fichiers *.sql (préfixer par 001_, 002_, etc...) triés par nom qui n'ont pas encore été joués.
     *
     * @param string $migrationsDir Dossier contenant les scripts SQL (defaut: '/migrations')
     * @param bool   $fresh         Si true, supprime toutes les tables avant de rejouer les migrations depuis zéro (defaut: false)
     * @return array Liste des noms de fichiers de migration exécutés pendant cet appel
     * @throws Exception lève une {@code PDOException} si un fichier SQL échoue pendant l'exécution de la migration
     */
    public function migrate(string $migrationsDir = __DIR__ . '/migrations', bool $fresh = false): array
    {
        if ($fresh) {
            self::$PDO->exec('SET FOREIGN_KEY_CHECKS = 0');
            $tables = self::$PDO->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
            foreach ($tables as $table) {
                self::$PDO->exec("DROP TABLE IF EXISTS `{$table}`");
            }
            self::$PDO->exec('SET FOREIGN_KEY_CHECKS = 1');
        }

        $this->ensureMigrationsTable();

        $applied = self::$PDO->query('SELECT migration FROM migrations')->fetchAll(PDO::FETCH_COLUMN);
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
                $stmt = self::$PDO->prepare('INSERT INTO migrations (migration) VALUES (?)');
                $stmt->execute([$name]);
                $executed[] = $name;
            } catch (PDOException $e) {
                throw new Exception("Échec de la migration '{$name}' : " . $e->getMessage(), 0, $e);
            }
        }

        return $executed;
    }
}