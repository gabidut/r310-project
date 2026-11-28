<?php
/**
 * Routeur de développement pour le serveur interne PHP (php -S localhost:8000 dev-router.php).
 * Redirige les requêtes /back vers le back-end PHP, sert les assets front,
 * et redirige les routes de navigation SPA vers front/index.html.
 *
 * @author gabidut
 */

$rawUri = $_SERVER['REQUEST_URI'] ?? '/';
$uri = urldecode(parse_url($rawUri, PHP_URL_PATH));

// 1. Requêtes vers l'API Back-end (/back/...)
if (str_starts_with($uri, '/back')) {
    if ($uri !== '/back/' && $uri !== '/back' && is_file(__DIR__ . $uri)) {
        return false; // Laisse PHP servir le fichier statique s'il existe
    }
    require __DIR__ . '/back/index.php';
    return;
}

// 2. Fichiers statiques du Front-end
$cleanUri = preg_replace('#^/front#', '', $uri);
if ($cleanUri === '') {
    $cleanUri = '/';
}

$frontFile = __DIR__ . '/front' . $cleanUri;
if ($cleanUri !== '/' && is_file($frontFile)) {
    $ext = pathinfo($frontFile, PATHINFO_EXTENSION);
    $mimes = [
        'css'  => 'text/css',
        'js'   => 'application/javascript',
        'mjs'  => 'application/javascript',
        'svg'  => 'image/svg+xml',
        'json' => 'application/json',
        'html' => 'text/html; charset=utf-8',
        'png'  => 'image/png',
        'jpg'  => 'image/jpeg',
        'jpeg' => 'image/jpeg',
        'ico'  => 'image/x-icon',
        'woff' => 'font/woff',
        'woff2'=> 'font/woff2',
        'ttf'  => 'font/ttf',
    ];
    header('Content-Type: ' . ($mimes[$ext] ?? (mime_content_type($frontFile) ?: 'application/octet-stream')));
    readfile($frontFile);
    return;
}

// 3. Toutes les autres routes Web non-back : SPA front/index.html
$indexFile = __DIR__ . '/front/index.html';
if (file_exists($indexFile)) {
    header('Content-Type: text/html; charset=utf-8');
    readfile($indexFile);
    return;
}
