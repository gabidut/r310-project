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
 * @version 1.1
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
            $_ENV['DB_PORT'] ?? '3306',
            $_ENV['DB_NAME'],
            $_ENV['DB_CHARSET'] ?? 'utf8mb4'
        );

        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        self::$PDO = new PDO($dsn, $_ENV['DB_USER'] ?? '', $_ENV['DB_PASS'] ?? '', $options);
    }

    /**
     * Methode de destruction de l'instance MySQL
     */
    public function __destruct() {
        self::$PDO = null ;
    }

    /**
     * Methode clone verrouillée via une exception
     */
    public function __clone() {
        throw new Exception('Impossible de cloner une connexion SQL');
    }


    /**
     * Méthode pour l'appel des fonctions de l'objet PDO quand
     * elles ne sont pas définies dans la classe
     *
     * @param type $method
     * @param type $params
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
     * Fournit l'unique instance du Singleton
     *
     * @return Database
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
}