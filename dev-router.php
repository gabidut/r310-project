<?php
/**
 * @author gabidut
 */

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

if (str_starts_with($uri, '/back')) {
    if ($uri !== '/back/' && is_file(__DIR__ . $uri)) {
        return false; // Laisse PHP servir le fichier existant
    }
    require __DIR__ . '/back/index.php';
    return;
}

$frontFile = __DIR__ . '/front' . $uri;
if ($uri !== '/' && is_file($frontFile)) {
    $ext = pathinfo($frontFile, PATHINFO_EXTENSION);
    $mimes = ['css' => 'text/css', 'js' => 'application/javascript', 'svg' => 'image/svg+xml', 'json' => 'application/json'];
    header('Content-Type: ' . ($mimes[$ext] ?? mime_content_type($frontFile)));
    readfile($frontFile);
    return;
}


?>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>dev router</title>
</head>
<body>
<h1>Perdu?</h1>
<p>Vous trouverez le backend ici : <a href="/back">/back</a></p>
<p>Vous trouverez le frontend ici : <a href="/front">/front</a></
</body>
</html>
