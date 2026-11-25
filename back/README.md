# Documentation back-end

Guide destiné aux développeurs qui travaillent sur la partie serveur (PHP / MySQL / API JSON).

## Sommaire

1. [Vue d'ensemble](#1-vue-densemble)
2. [Structure du projet](#2-structure-du-projet)
3. [Démarrage rapide](#3-démarrage-rapide)
4. [Configuration (`.env`)](#4-configuration-env)
5. [Le noyau (`core/` et `db/`)](#5-le-noyau-core-et-db)
    - [5.1 Router](#51-router)
    - [5.2 Controller](#52-controller-classe-abstraite)
    - [5.3 Model](#53-model-classe-abstraite)
    - [5.4 Database](#54-database)
    - [5.5 Resource](#55-resource-classe-abstraite)
    - [5.6 SessionManager](#56-sessionmanager)
    - [5.7 CookieManager](#57-cookiemanager)
6. [Les modules (`modules/`)](#6-les-modules-modules)
    - [6.1 Le fichier `index.php` d'un module](#61-le-fichier-indexphp-dun-module)
    - [6.2 Créer un nouveau module : pas à pas](#62-créer-un-nouveau-module--pas-à-pas)
7. [Conventions et bonnes pratiques](#7-conventions)


## 1. Vue d'ensemble

Le back-end est une petite API JSON en PHP, organisée en deux parties :

- **le noyau** (`core/` et `db/`) : classes de base partagées par tout le projet (routeur, contrôleur, modèle, ressource, session, cookies, base de données) ;
- **les modules** (`modules/<nom>/`) : une fonctionnalité métier = un dossier (ex. `acteurs`). C'est ici que vous travaillerez au quotidien.

Flux d'une requête :

1. Le `Router` reçoit l'URL et la méthode HTTP.
2. Il trouve la route correspondante (déclarée dans le `index.php` d'un module).
3. Il instancie le **Controller** et appelle la méthode ciblée, avec les paramètres d'URL.
4. Le Controller utilise un **Model** pour lire ou écrire en base.
5. Le résultat est formaté par une **Resource** et renvoyé en JSON.

## 2. Structure du projet

```
projet/
├── .env                      # identifiants BDD (jamais versionné)
├── db/
│   ├── Database.php          # connexion PDO + transactions + migrations
│   └── migrations/           # scripts SQL (001_..., 002_...)
├── core/
│   ├── Router.php
│   ├── Controller.php        # classe de base des contrôleurs
│   ├── Model.php             # classe de base des modèles
│   ├── Resource.php          # classe de base des réponses JSON
│   ├── SessionManager.php
│   └── CookieManager.php
└── modules/
    └── <domaine>/            # un module = un domaine métier
        ├── controllers/      # ex. MainActeursController.php
        ├── models/           # ex. ActeurModel.php
        ├── resources/        # ex. ActeurResource.php
        └── index.php         # déclaration des routes du module
```

> Règle d'or : **on ne modifie pas `core/` ni `db/` pour une fonctionnalité métier.** Tout le code spécifique va dans `modules/`.

## 3. Démarrage rapide

1. Créer le fichier `.env` à la racine (voir section 4).
2. Lancer les migrations pour créer les tables (voir section 5.4).
3. Vérifier que les classes sont chargées (`require_once` ou autoloader) :

```php
require_once 'db/Database.php';
require_once 'core/SessionManager.php';
require_once 'core/CookieManager.php';
```

> `Database`, `SessionManager` et `CookieManager` sont des **Singletons** : on ne fait jamais `new`, toujours `getInstance()`. Le clonage lève une `Exception`.

## 4. Configuration (`.env`)

`Database.php` lit le fichier `.env` situé dans le dossier parent de `db/` et charge chaque ligne `CLE=valeur` dans `$_ENV` et `putenv()`.

```ini
# .env
DB_HOST=localhost
DB_PORT=3306
DB_NAME=ma_base
DB_CHARSET=utf8mb4
DB_USER=root
DB_PASS=secret
```

| Variable | Rôle |
| --- | --- |
| `DB_HOST` | Hôte du serveur MySQL |
| `DB_PORT` | Port MySQL (généralement `3306`) |
| `DB_NAME` | Nom de la base de données |
| `DB_CHARSET` | Jeu de caractères (ex. `utf8mb4`) |
| `DB_USER` | Utilisateur MySQL |
| `DB_PASS` | Mot de passe MySQL |

Règles du parseur :

- les lignes vides et celles commençant par `#` sont ignorées ;
- les guillemets simples ou doubles autour des valeurs sont retirés (`DB_PASS="abc"` devient `abc`) ;
- chaque ligne non commentée doit contenir un `=` ;
- **ne jamais versionner `.env`** (l'ajouter au `.gitignore`).

## 5. Le noyau (`core/` et `db/`)

### 5.1 Router

Routage HTTP simple avec paramètres dynamiques.

```php
$router = new \core\Router('/api');   // préfixe optionnel, ignoré lors de la résolution
$router->addRoute('users/{id}', 'UserController@show', 'GET');
$router->route($_SERVER['REQUEST_URI']);
```

| Élément | Détail |
| --- | --- |
| `addRoute($uri, $action, $httpMethod = 'ANY')` | Enregistre une route. Méthodes : `ANY`, `GET`, `POST`, `PUT`, `DELETE` |
| Paramètres dynamiques | `{id}` ou `:id` dans l'URI. Les valeurs capturées sont passées **dans l'ordre** à la méthode du contrôleur |
| Format de l'action | `Controller@methode` (obligatoire, sinon `Exception`) |
| Route inconnue | Réponse JSON `{"error": "Route introuvable"}` avec le code `404` |
| Contrôleur ou méthode inexistant | `Exception` |

Exemple : la route `acteurs/query/:queryIndex` appelle `query($queryIndex)` avec la valeur présente dans l'URL. **Le nom du paramètre PHP n'a pas d'importance, seul l'ordre compte.**

### 5.2 Controller (classe abstraite)

Tout contrôleur étend `core\Controller`. Il récupère automatiquement :

- `$this->session` : le `SessionManager` ;
- `$this->cookies` : le `CookieManager` ;
- `$this->getInput()` : les données envoyées par le client (JSON brut du `fetch`, sinon `$_POST`), toujours sous forme de tableau.

> Si votre contrôleur définit son propre `__construct()`, appelez `parent::__construct()`.

### 5.3 Model (classe abstraite)

Tout modèle étend `core\Model` et dispose de `$this->db`, l'instance unique de `Database`. Toutes les méthodes PDO y sont accessibles (`prepare`, `query`, `exec`, `lastInsertId`, `beginTransaction`…).

### 5.4 Database

Connexion MySQL via PDO, créée une seule fois puis réutilisée.

```php
$db = Database::getInstance();   // depuis un fichier avec namespace : \Database::getInstance()
```

Options PDO appliquées par défaut :

| Option | Valeur | Effet |
| --- | --- | --- |
| `ATTR_ERRMODE` | `ERRMODE_EXCEPTION` | Les erreurs SQL lèvent une `PDOException` |
| `ATTR_DEFAULT_FETCH_MODE` | `FETCH_ASSOC` | Résultats en tableaux associatifs |
| `ATTR_EMULATE_PREPARES` | `false` | Vraies requêtes préparées (meilleure protection contre l'injection SQL) |

**Requêtes**

```php
// Une ligne
$stmt = $db->prepare('SELECT * FROM users WHERE email = :email');
$stmt->execute(['email' => $email]);
$user = $stmt->fetch();          // tableau associatif ou false

// Plusieurs lignes
$users = $db->query('SELECT id, nom FROM users')->fetchAll();

// Insertion + ID
$stmt = $db->prepare('INSERT INTO users (nom) VALUES (?)');
$stmt->execute([$nom]);
$id = $db->lastInsertId();
```

> Toujours `prepare()` + `execute()` avec des paramètres. **Jamais de variable concaténée dans une requête.**

**Transactions : `transaction(callable $callback)`**

Exécute plusieurs requêtes de façon atomique : validation automatique si tout réussit, rollback puis relance de l'exception en cas d'erreur. Le callback reçoit l'instance `Database` et sa valeur de retour est renvoyée.

```php
$orderId = $db->transaction(function ($db) use ($userId, $total) {
    $db->prepare('INSERT INTO commandes (user_id, total) VALUES (?, ?)')->execute([$userId, $total]);
    $id = $db->lastInsertId();
    $db->prepare('INSERT INTO historique (commande_id) VALUES (?)')->execute([$id]);
    return $id;
});
```

Pour annuler volontairement : lever une exception dans le callback.

> Bon à savoir :
>
> - les transactions imbriquées ne sont pas supportées (pas de `transaction()` ni de `beginTransaction()` dans un callback) ;
> - avec MySQL, `CREATE`, `ALTER`, `DROP`… provoquent un commit implicite et ne peuvent pas être annulés.

**Migrations : `migrate(string $migrationsDir = db/migrations, bool $fresh = false)`**

- Exécute les fichiers `*.sql` du dossier, triés par nom (préfixer : `001_`, `002_`…), qui n'ont pas encore été joués.
- Mémorise les fichiers appliqués dans la table technique `migrations` (créée automatiquement).
- Retourne la liste des fichiers exécutés pendant l'appel.
- Si un fichier échoue, une `Exception` est levée avec le nom de la migration.

```php
$done = Database::getInstance()->migrate();
```

> **Attention : `migrate(..., true)` (`$fresh`) supprime TOUTES les tables avant de rejouer les migrations.** À réserver au développement local, jamais en production.

### 5.5 Resource (classe abstraite)

Sépare la structure interne de la base du format public exposé au client (renommage de clés, masquage de colonnes sensibles) et envoie les réponses JSON.

| Méthode | Description |
| --- | --- |
| `toArray()` | **Abstraite** : à implémenter, définit le format de sortie d'une ligne |
| `send(int $status = 200)` | Envoie un élément formaté |
| `Resource::collection(array $items, int $status = 200)` | Envoie une liste, chaque ligne passant par `toArray()` |
| `Resource::error(string $message, int $status = 400)` | Envoie `{"error": "..."}` avec le code HTTP voulu |

> Chaque envoi termine le script (`exit`). Rien de ce qui suit un `send()`, `collection()` ou `error()` n'est exécuté.

### 5.6 SessionManager

Session PHP démarrée automatiquement au premier `getInstance()` (durée `0`, chemin `/`, `httponly`, `samesite=Lax`). Dans un contrôleur, utiliser `$this->session`.

| Méthode | Description |
| --- | --- |
| `set($key, $value)` | Écrit ou met à jour une valeur |
| `setMultiple(array $data)` | Écrit plusieurs valeurs |
| `get($key, $default = null)` | Lit une valeur (ou `$default`) |
| `has($key)` | `true` si la clé existe |
| `remove($key)` | Supprime une clé |
| `all()` | Tout le contenu de la session |
| `regenerate()` | Régénère l'ID de session |
| `flash($key, $value = null)` | Message éphémère : écriture si valeur non nulle, lecture unique sinon |
| `destroy()` | Vide la session et supprime le cookie de session |

Syntaxe « propriété » également disponible : `$session->nom = 'Toto'`, `echo $session->nom`, `isset(...)`, `unset(...)`.

```php
// Après une connexion réussie : toujours régénérer l'ID (protection contre la fixation de session)
$this->session->regenerate();
$this->session->set('user_id', $user['id']);

// Message flash : page A écrit, page B lit (et supprime)
$this->session->flash('success', 'Profil mis à jour !');
$msg = $this->session->flash('success');
```

### 5.7 CookieManager

Gestion des cookies avec encodage JSON automatique des tableaux et objets. Tous les cookies utilisent `path=/` et `samesite=Lax`. Dans un contrôleur, utiliser `$this->cookies`.

| Méthode | Description |
| --- | --- |
| `set($name, $value, $days = 30, $httpOnly = true)` | Crée ou met à jour un cookie |
| `get($name, $default = null)` | Lit un cookie (décode le JSON si tableau) |
| `has($name)` | `true` si le cookie existe |
| `remove($name)` | Supprime le cookie |
| `all()` | Tous les cookies |

```php
$this->cookies->set('theme', 'dark');                                   // 30 jours, httpOnly
$this->cookies->set('prefs', ['lang' => 'fr', 'notif' => true], 90, false); // lisible en JS
$prefs = $this->cookies->get('prefs');                                  // tableau
```

Bon à savoir :

- `set()` et `remove()` mettent aussi à jour `$_COOKIE` : la valeur est lisible immédiatement ;
- ils doivent être appelés **avant toute sortie** (sinon erreur « headers already sent ») ;
- un objet est restitué sous forme de tableau associatif ; une valeur JSON scalaire est renvoyée en chaîne ;
- le flag `Secure` n'est pas défini : à ajouter dans `setcookie()` en production sous HTTPS ;
- **jamais de donnée sensible dans un cookie** (mot de passe, jeton privé) : utiliser la session.

## 6. Les modules (`modules/`)

Un module regroupe tout ce qui concerne un domaine métier. Exemple avec `acteurs` :

```
modules/acteurs/
├── controllers/   # reçoivent la requête, orchestrent
├── models/        # accès à la base de données (SQL)
├── resources/     # format JSON de sortie
└── index.php      # routes du module
```

| Dossier | Étend | Responsabilité | À éviter |
| --- | --- | --- | --- |
| `controllers/` | `core\Controller` | Lire l'entrée, valider, appeler le modèle, répondre | Écrire du SQL |
| `models/` | `core\Model` | Requêtes SQL via `$this->db` | Envoyer une réponse HTTP |
| `resources/` | `core\Resource` | Transformer une ligne SQL en tableau public | Appeler la base |
| `index.php` | — | Déclarer les routes | Y mettre de la logique |

### 6.1 Le fichier `index.php` d'un module

Il **retourne** un tableau de routes. Chaque route est : `[méthode HTTP, URI, action]`.

```php
<?php

return [
    'routes' => [
        ['GET', 'acteurs', 'acteurs/MainActeursController@index'],
        ['GET', 'acteurs/query/:queryIndex', 'acteurs/MainActeursController@query'],
    ],
];
```

| Champ | Exemple | Signification |
| --- | --- | --- |
| Méthode HTTP | `'GET'` | `GET`, `POST`, `PUT`, `DELETE` ou `ANY` |
| URI | `'acteurs/query/:queryIndex'` | Chemin ; `:nom` ou `{nom}` = paramètre dynamique |
| Action | `'acteurs/MainActeursController@index'` | `<module>/<Contrôleur>@<méthode>` |

Avec cet exemple : `GET /acteurs` appelle `index()`, et `GET /acteurs/query/3` appelle `query('3')`. Les paramètres d'URL arrivent toujours sous forme de **chaînes**.

### 6.2 Créer un nouveau module : pas à pas

1. Créer le dossier `modules/<nom>/` avec `controllers/`, `models/`, `resources/` et un `index.php`.
2. Écrire le **modèle** (SQL).
3. Écrire la **resource** (format de sortie).
4. Écrire le **contrôleur** (logique de la requête).
5. Déclarer les **routes** dans `index.php`.
6. Si besoin, ajouter une migration SQL dans `db/migrations/` (par ex. `003_create_acteurs.sql`).

> Les exemples ci-dessous sont indicatifs (table `acteurs` avec `id`, `nom`, `prenom`). Adaptez les `namespace` à la convention de chargement de classes du projet.

**Modèle : `models/ActeurModel.php`**

```php
<?php

namespace modules\acteurs\models;

use core\Model;

class ActeurModel extends Model
{
    public function findAll(): array
    {
        return $this->db->query('SELECT id, nom, prenom FROM acteurs ORDER BY nom')->fetchAll();
    }

    public function findById(int $id): array|false
    {
        $stmt = $this->db->prepare('SELECT id, nom, prenom FROM acteurs WHERE id = :id');
        $stmt->execute(['id' => $id]);
        return $stmt->fetch();
    }

    public function create(string $nom, string $prenom): int
    {
        $stmt = $this->db->prepare('INSERT INTO acteurs (nom, prenom) VALUES (?, ?)');
        $stmt->execute([$nom, $prenom]);
        return (int) $this->db->lastInsertId();
    }
}
```

**Resource : `resources/ActeurResource.php`**

```php
<?php

namespace modules\acteurs\resources;

use core\Resource;

class ActeurResource extends Resource
{
    public function toArray(): array
    {
        return [
            'id'        => (int) $this->resource['id'],
            'lastName'  => $this->resource['nom'],
            'firstName' => $this->resource['prenom'],
            // les colonnes non listées ici ne sont jamais exposées
        ];
    }
}
```

**Contrôleur : `controllers/MainActeursController.php`**

```php
<?php

namespace modules\acteurs\controllers;

use core\Controller;
use core\Resource;
use modules\acteurs\models\ActeurModel;
use modules\acteurs\resources\ActeurResource;

class MainActeursController extends Controller
{
    // GET /acteurs
    public function index(): void
    {
        $acteurs = (new ActeurModel())->findAll();
        ActeurResource::collection($acteurs);
    }

    // GET /acteurs/:id
    public function show(string $id): void
    {
        $acteur = (new ActeurModel())->findById((int) $id);

        if (!$acteur) {
            Resource::error('Acteur introuvable', 404);
        }

        (new ActeurResource($acteur))->send();
    }

    // POST /acteurs
    public function store(): void
    {
        $input = $this->getInput();

        if (empty($input['nom']) || empty($input['prenom'])) {
            Resource::error('Les champs nom et prenom sont obligatoires', 400);
        }

        $id = (new ActeurModel())->create($input['nom'], $input['prenom']);
        $acteur = (new ActeurModel())->findById($id);

        (new ActeurResource($acteur))->send(201);
    }
}
```

**Routes : `index.php`**

```php
<?php

return [
    'routes' => [
        ['GET',  'acteurs',      'acteurs/MainActeursController@index'],
        ['GET',  'acteurs/:id',  'acteurs/MainActeursController@show'],
        ['POST', 'acteurs',      'acteurs/MainActeursController@store'],
    ],
];
```

## 7. Conventions et bonnes pratiques

- **Nommage** : contrôleurs en `XxxController`, modèles en `XxxModel`, resources en `XxxResource`, un fichier par classe, nom du fichier identique au nom de la classe.
- **SQL** : uniquement dans les modèles, uniquement avec des requêtes préparées.
- **Réponses** : toujours via `Resource` (`send`, `collection`, `error`) pour garder un format JSON cohérent.
- **Codes HTTP** : `200` lecture/mise à jour, `201` création, `400` données invalides, `401` non connecté, `403` interdit, `404` introuvable.
- **Validation** : valider les entrées (`getInput()` et paramètres d'URL) dans le contrôleur avant tout appel au modèle.
- **Plusieurs écritures liées** : les entourer d'un `$this->db->transaction(...)`.
- **Secrets** : uniquement dans `.env`, jamais dans le code ni dans Git.
- **Sécurité** : `session->regenerate()` après chaque connexion ; pas de données sensibles dans les cookies.
- **Ne pas modifier `core/`** sans en parler à l'équipe : tous les modules en dépendent.

## 8. Points à connaître (pièges fréquents)

- `exit` après chaque réponse : un `Resource::error()` interrompt le script, inutile de faire `return` derrière.
- Les paramètres d'URL sont passés **par position** et sont des **chaînes** (penser à `(int)`).
- `Database` est dans l'espace de noms global : depuis un fichier avec `namespace`, écrire `\Database` (ou `use Database;`).
- `set()` / `remove()` de cookies et `session_start()` doivent précéder toute sortie HTML.
- Pas de transaction imbriquée.
- `migrate(..., true)` efface toute la base.

