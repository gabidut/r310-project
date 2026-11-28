<?php

/**
 * Script CLI pour la gestion et l'exécution des migrations de base de données.
 *
 * Utilisation :
 *   php back/migrate.php           Applique toutes les migrations en attente
 *   php back/migrate.php --fresh   Réinitialise la base et rejoue toutes les migrations
 *   php back/migrate.php --status  Affiche l'état des migrations (appliquées / en attente)
 *   php back/migrate.php --help    Affiche l'aide
 *
 * @author  gabidut
 * @version 1.0
 */

if (php_sapi_name() !== 'cli') {
    http_response_code(403);
    echo "Accès refusé : ce script doit être exécuté en ligne de commande (CLI).\n";
    exit(1);
}

require_once __DIR__ . '/autoload.php';

$options = getopt('h', ['fresh', 'status', 'help']);

if (isset($options['help']) || isset($options['h'])) {
    echo "=== Gestionnaire de Migrations (CLI) ===\n";
    echo "Usage :\n";
    echo "  php back/migrate.php           Applique les migrations en attente\n";
    echo "  php back/migrate.php --fresh   Supprime toutes les tables et réapplique les migrations\n";
    echo "  php back/migrate.php --status  Affiche l'état de chaque fichier de migration\n";
    echo "  php back/migrate.php --help    Affiche cette aide\n\n";
    exit(0);
}

try {
    $db = Database::getInstance();

    if (isset($options['status'])) {
        echo "=== État des migrations ===\n";
        $status = $db->getMigrationStatus();
        if (empty($status)) {
            echo "Aucun fichier de migration trouvé dans back/db/migrations/.\n";
            exit(0);
        }

        foreach ($status as $item) {
            $tag = $item['applied'] ? "\033[32m[APPLIQUÉE]\033[0m" : "\033[33m[EN ATTENTE]\033[0m";
            $date = $item['executed_at'] ? " (exécutée le " . $item['executed_at'] . ")" : "";
            echo sprintf("  %-35s %s%s\n", $item['filename'], $tag, $date);
        }
        echo "\n";
        exit(0);
    }

    $isFresh = isset($options['fresh']);
    if ($isFresh) {
        echo "ATTENTION : Vous avez demandé une réinitialisation complète (--fresh).\n";
        echo "Toutes les tables vont être supprimées et recréées.\n\n";
    }

    echo "Vérification et application des migrations...\n";
    $executed = $db->migrate(__DIR__ . '/db/migrations', $isFresh);

    if (empty($executed)) {
        echo "Aucune nouvelle migration à exécuter. La base de données est déjà à jour.\n";
    } else {
        echo "\n" . count($executed) . " migration(s) exécutée(s) avec succès.\n";
    }
} catch (\Throwable $e) {
    echo "\n\033[31m[ERREUR]\033[0m " . $e->getMessage() . "\n";
    exit(1);
}
