# 🚀 Guide du Développeur — Back-end R310

Bienvenue sur la documentation officielle du back-end du projet **R310** ! 

Que tu sois ici pour ajouter une route, brancher une table ou comprendre pourquoi ton JSON ne répond pas, ce guide est fait pour toi. On a fait en sorte de rendre le tout digeste, structuré, et sans prise de tête inutile.

> ⚡ **Pressé(e) ?** Tu veux juste les commandes, snippets et règles indispensables ? Jette un œil à notre condensé ultra-rapide : [ESSENTIALS.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/ESSENTIALS.md).

---

## 📑 Sommaire

1. [Vue d'ensemble (Le back-end en 2 minutes)](#1-vue-densemble-le-back-end-en-2-minutes)
2. [Démarrage rapide](#2-démarrage-rapide)
3. [Structure du projet & Règle d'or](#3-structure-du-projet--règle-dor)
4. [Configuration (`.env`)](#4-configuration-env)
5. [Le noyau (`core/` et `db/`)](#5-le-noyau-core-et-db)
   - [5.1 Router (L'aiguilleur du ciel)](#51-router-laiguilleur-du-ciel)
   - [5.2 Controller (Le chef d'orchestre)](#52-controller-le-chef-dorchestre)
   - [5.3 Database & Transactions](#53-database--transactions)
   - [5.4 Les Migrations (Sans sueurs froides)](#54-les-migrations-sans-sueurs-froides)
   - [5.5 Resource (La reine du JSON)](#55-resource-la-reine-du-json)
   - [5.6 SessionManager & CookieManager](#56-sessionmanager--cookiemanager)
6. [Les modèles de données (`models/`)](#6-les-modèles-de-données-models)
   - [6.1 Organisation par domaines (8 dossiers)](#61-organisation-par-domaines-8-dossiers)
   - [6.2 Les super-pouvoirs POO (`findById` et relations)](#62-les-super-pouvoirs-poo-findbyid-et-relations)
   - [6.3 Requêtes SQL personnalisées et écritures](#63-requêtes-sql-personnalisées-et-écritures)
7. [Les modules métier (`modules/`)](#7-les-modules-métier-modules)
   - [7.1 Anatomie d'un module](#71-anatomie-dun-module)
   - [7.2 Déclarer des routes dans `index.php`](#72-déclarer-des-routes-dans-indexphp)
   - [7.3 Tuto : Créer une fonctionnalité de A à Z](#73-tuto--créer-une-fonctionnalité-de-a-à-z)
8. [Bonnes pratiques & pièges qui font perdre 2h](#8-bonnes-pratiques--pièges-qui-font-perdre-2h)
9. [Annexes et liens utiles](#9-annexes-et-liens-utiles)

---

## 1. Vue d'ensemble (Le back-end en 2 minutes)

Le back-end est une **API RESTful JSON** développée en **PHP 8.4+** et **MySQL**, basée sur une architecture légère **MRC** (*Model - Resource - Controller*) pensée sur-mesure pour notre projet.

Il est découpé en deux grandes zones :
- 🧠 **Le noyau (`core/` et `db/`)** : Les fondations solides (routeur, contrôleur de base, gestionnaire PDO, sessions, cookies, réponses JSON).
- 🛠️ **Les modules (`modules/<domaine>/`)** : Là où vit la logique métier (acteurs, scolarité, vacataires, décisions…). C'est ici que tu vas passer 99% de ton temps.

### 🔄 Le voyage d'une requête HTTP

```
                    ┌─────────────────────────┐
                    │ Client (Navigateur/App) │
                    └───────────┬─────────────┘
                                │  GET /api/acteurs/42
                                ▼
                    ┌─────────────────────────┐
                    │       core\Router       │  Trouve le bon contrôleur
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │    MainController       │  Valide l'entrée
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │     Modèle (POO/SQL)    │  Récupère les données
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │     core\Resource       │  Nettoie, formate en JSON
                    └───────────┬─────────────┘
                                │  {"status":200, "data":{...}}
                                ▼
                    ┌─────────────────────────┐
                    │      Client content     │
                    └─────────────────────────┘
```

---

## 2. Démarrage rapide

### Étape 1 : Le fichier `.env`
Duplique le fichier `.env.example` en `.env` dans le dossier `back/` et configure tes accès MySQL locaux :
```ini
DB_HOST=localhost
DB_PORT=3306
DB_NAME=r310_db
DB_CHARSET=utf8mb4
DB_USER=root
DB_PASS=
DB_AUTO_MIGRATE=true
```

> 💡 Pour les détails pas-à-pas avec capture d'écran sur Laragon / HeidiSQL, consulte [INIT_DB.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INIT_DB.md).

### Étape 2 : Lancer le serveur local
À la racine du projet, lance la commande magique :
```bash
php -S localhost:8000 dev-router.php
```

### Étape 3 : Vérifier que la BDD tourne
Grâce à notre outil CLI de migration :
```bash
php back/migrate.php --status
```
Si des migrations sont en attente, applique-les simplement avec :
```bash
php back/migrate.php
```
🎉 Ton API est prête sur `http://localhost:8000/back/` !

---

## 3. Structure du projet & Règle d'or

Voici l'arbre généalogique du back-end :

```text
back/
├── .env                      # 🤫 Tes identifiants secrets (JAMAIS dans Git !)
├── .env.example              # Exemple de configuration
├── autoload.php              # Chargement automatique malin des classes
├── index.php                 # Point d'entrée unique de l'API
├── migrate.php               # Outil CLI pour gérer les migrations
├── dev-router.php            # Routeur pour le serveur PHP intégré (à la racine)
├── core/                     # 🛡️ LE NOYAU (Interdit d'y toucher !)
│   ├── Router.php            # Aiguillage des URL
│   ├── Controller.php        # Contrôleur parent
│   ├── Model.php             # Modèle parent avec hydratation
│   ├── Resource.php          # Réponses JSON formatées
│   ├── SessionManager.php    # Sessions sécurisées
│   └── CookieManager.php     # Cookies simplifiés
├── db/                       # 🗄️ LA BASE DE DONNÉES
│   ├── Database.php          # Singleton PDO + Transactions + Migrations
│   └── migrations/           # Scripts SQL (001_MLR3.sql, etc.)
├── models/                   # 📦 LES MODÈLES POO (57 tables typées !)
│   ├── acteurs/              # Personne, Etudiant, Enseignant, Role...
│   ├── vacataires/           # Vacataire, PaiementVacataire...
│   ├── scolarite/            # Promo, Matiere, Evaluation, Note...
│   ├── apprentissage/        # Apprenti, Stagiaire, Entreprise...
│   ├── decision/             # Decision, CompteRendu, Reunion...
│   ├── vieetudiante/         # Absence, Sanction, Gravite, BDE...
│   ├── poursuiteetude/       # EcoleSup, Ambassade, Parcoursup...
│   └── communication/        # Evenement, Mail, PieceJointe...
└── modules/                  # 🚀 VOS MODULES MÉTIER
    └── <domaine>/            # ex: acteurs, vacataires, scolarite...
        ├── controllers/      # Contrôleurs spécifiques
        ├── models/           # Modèles spécifiques ou requêtes SQL custom
        ├── resources/        # Resources spécifiques
        └── index.php         # Déclaration des routes du module
```

> 🏆 **La Règle d'or de l'équipe** :  
> **On ne modifie JAMAIS `core/` ni `db/` pour ajouter une fonctionnalité.**  
> Tout ton travail s'effectue dans `modules/<nom-de-ton-domaine>/`. Si tu penses avoir besoin de modifier le noyau, parles-en d'abord à toute l'équipe !

---

## 4. Configuration (`.env`)

Le fichier `back/.env` est chargé automatiquement par `Database.php`. Il alimente `$_ENV` ainsi que `getenv()`.

| Variable | Exemple | Rôle |
| :--- | :--- | :--- |
| `DB_HOST` | `localhost` | Hôte MySQL |
| `DB_PORT` | `3306` | Port du serveur MySQL |
| `DB_NAME` | `r310_db` | Nom de la base de données |
| `DB_CHARSET`| `utf8mb4` | Encodage (garde `utf8mb4` pour supporter les accents et emojis) |
| `DB_USER` | `root` | Nom d'utilisateur MySQL |
| `DB_PASS` | `secret` | Mot de passe MySQL |
| `DB_AUTO_MIGRATE` | `true` | Si `true`, vérifie les migrations à chaque requête sans impacter les perfs |

---

## 5. Le noyau (`core/` et `db/`)

### 5.1 Router (L'aiguilleur du ciel)

Le routeur associe une URL et une méthode HTTP à une action de contrôleur.

```php
$router->addRoute('utilisateurs/:id', 'utilisateurs/UserController@show', 'GET');
```

- **Paramètres dynamiques** : écris `:id` ou `{id}`. La valeur capturée sera envoyée **dans le même ordre** en argument de la méthode de ton contrôleur.
- **Format de l'action** : `<nom-du-module>/<NomDuControleur>@<nomDeLaMethode>`.
- **404 automatique** : Si l'URL n'existe pas, le routeur renvoie immédiatement une erreur JSON `404` avec `{"error": "Route introuvable"}`.

### 5.2 Controller (Le chef d'orchestre)

Chaque contrôleur hérite de `core\Controller`. Dès l'instanciation, tu bénéficies gratuitement de :
- `$this->session` : l'instance unique de `SessionManager`.
- `$this->cookies` : l'instance unique de `CookieManager`.
- `$this->getInput()` : tableau associatif contenant le JSON envoyé par le client (ou `$_POST` en secours).

```php
namespace modules\acteurs\controllers;

use core\Controller;

class ProfilController extends Controller
{
    public function update(): void
    {
        $body = $this->getInput(); // Directement un tableau PHP !
        $nom = $body['nom'] ?? null;
    }
}
```

### 5.3 Database & Transactions

La classe `Database` est un **Singleton** qui gère la connexion PDO unique. Pas de `new Database()`, on fait toujours :
```php
$db = Database::getInstance(); // Ou \Database::getInstance() si tu es dans un namespace
```

#### Les requêtes classiques (dans un Model) :
```php
// SELECT préparé
$stmt = $this->db->prepare("SELECT * FROM TD_PERSONNE WHERE PER_MAIL = ?");
$stmt->execute([$email]);
$utilisateur = $stmt->fetch();

// INSERT préparé
$stmt = $this->db->prepare("INSERT INTO TD_ROLE (ROL_ID, ROL_LIBELLE) VALUES (?, ?)");
$stmt->execute(['ROL_01', 'Administrateur']);
```

#### Les Transactions (atomiques) :
Si tu dois insérer plusieurs lignes liées (par exemple un vacataire et son premier paiement), utilise `transaction()` :
```php
$db->transaction(function ($db) use ($vacataireId, $montant) {
    $db->prepare("INSERT INTO TD_VACATAIRE ...")->execute([...]);
    $db->prepare("INSERT INTO TD_PAIEMENT_VACATAIRE ...")->execute([...]);
});
```
> Si une erreur survient au milieu, tout est annulé automatiquement (*rollback*) ! Pour forcer l'annulation manuelle, lève simplement une `Exception`.

### 5.4 Les Migrations (Sans sueurs froides)

Fini le temps où il fallait exporter manuellement un dump SQL et le passer sur Discord.

1. Tu as besoin d'une nouvelle table ? Crée un fichier `002_ma_nouvelle_table.sql` dans `back/db/migrations/`.
2. Lance :
   ```bash
   php back/migrate.php
   ```
3. C'est tout ! Le script exécute uniquement les nouveaux fichiers et enregistre son passage dans la table `migrations`.

> 🚀 **Performance** : Un fichier cache (`back/db/.migrations_cache`) permet de vérifier que tout est à jour en **0,05 milliseconde**, sans faire la moindre requête SQL !

### 5.5 Resource (La reine du JSON)

Les classes `Resource` s'assurent que ton API répond toujours avec un format JSON standard et propre :

```json
{
  "status": 200,
  "data": {
    "id": "PER_01",
    "nom": "Dupont",
    "prenom": "Jean"
  }
}
```

```php
// Pour un seul élément :
(new PersonneResource($personne))->send(200);

// Pour une liste (collection) :
PersonneResource::collection($listePersonnes, 200);

// En cas de pépin :
Resource::error("Cet utilisateur n'existe pas", 404);
```

> ⚠️ **Attention piège classique** : Les méthodes `send()`, `collection()` et `error()` exécutent un `exit;` en interne ! Tout code écrit après ces appels ne sera jamais exécuté.

### 5.6 SessionManager & CookieManager

#### La Session (`$this->session`)
La session PHP est configurée proprement dès le départ (`httponly`, `samesite=Lax`).
```php
// Stocker en session
$this->session->set('user_id', $user->PER_ID);

// Régénérer l'ID (à faire OBLIGATOIREMENT après le login !)
$this->session->regenerate();

// Récupérer une info
$userId = $this->session->get('user_id');

// Message flash (auto-détruit après lecture)
$this->session->flash('info', 'Mot de passe mis à jour !');
```

#### Les Cookies (`$this->cookies`)
```php
// Poser un cookie pour 30 jours
$this->cookies->set('theme', 'dark', 30);

// Lire le cookie (décode même les tableaux JSON automatiquement !)
$theme = $this->cookies->get('theme', 'light');
```

---

## 6. Les modèles de données (`models/`)

### 6.1 Organisation par domaines (8 dossiers)

Toutes les 57 tables de notre schéma SQL possèdent un modèle orienté objet dédié dans `back/models/` :

```text
models/
├── acteurs/          # Personnes, Etudiants, Enseignants, Rôles
├── vacataires/       # Vacataires, Paiements, Dossiers, Checklists
├── scolarite/        # Promos, Matières, Évaluations, Notes, Jurys
├── apprentissage/    # Apprentis, Stagiaires, Entreprises
├── decision/         # Décisions, Réunions, PV, Mots-clés
├── vieetudiante/     # Absences, Sanctions, Aménagements, BDE
├── poursuiteetude/   # Écoles supérieures, Souhaits, Parcoursup
└── communication/    # Mails types, Événements, Questions/FAQ
```

### 6.2 Les super-pouvoirs POO (`findById` et relations)

Chaque modèle POO possède des méthodes statiques et des méthodes de navigation :

```php
use models\acteurs\Personne;
use models\vacataires\Vacataire;

// 1. Recherche par clé primaire
$personne = Personne::findById('PER_001');
echo $personne->PER_NOM;

// 2. Récupérer toutes les lignes d'une table
$promos = Promo::findAll();

// 3. Navigation relationnelle intelligente
$vacataire = Vacataire::findById('PER_001');
if ($vacataire) {
    // Récupérer les paiements de ce vacataire
    $paiements = $vacataire->getPaiementVacataire();
    
    // Récupérer son dossier
    $dossier = $vacataire->getDossierVacataire();
}
```

> 🪄 **Alias universels** : Tu peux importer soit `models\vacataires\Vacataire`, soit directement `models\Vacataire`. L'autoloader comprend les deux !

### 6.3 Requêtes SQL personnalisées et écritures

Les modèles POO de `back/models/` sont optimisés pour la lecture et la navigation objet. Si tu as besoin d'une requête spécifique (jointure exotique, calcul de moyenne, insertion), crée un modèle dédié dans ton module :

```php
namespace modules\scolarite\models;

use core\Model;

class MoyenneModel extends Model
{
    public function calculerMoyennePromo(string $proId): float
    {
        $stmt = $this->db->prepare("
            SELECT AVG(RES_NOTE) as moyenne 
            FROM TD_RESULTAT R
            JOIN TD_ETUDIANT E ON R.ETU_ID = E.ETU_ID
            WHERE E.PRO_ID = ?
        ");
        $stmt->execute([$proId]);
        return (float) ($stmt->fetch()['moyenne'] ?? 0.0);
    }
}
```

---

## 7. Les modules métier (`modules/`)

### 7.1 Anatomie d'un module

Chaque fonctionnalité correspond à un sous-dossier de `back/modules/` :
```text
modules/vacataires/
├── controllers/      # Reçoivent les requêtes et pilotent la réponse
├── models/           # Requêtes SQL métier
├── resources/        # Formatage JSON
└── index.php         # Déclaration des routes
```

### 7.2 Déclarer des routes dans `index.php`

Le fichier `index.php` d'un module doit retourner un tableau contenant la clé `'routes'` :

```php
<?php

return [
    'routes' => [
        // [ Méthode, URI, 'Module/Contrôleur@méthode' ]
        ['GET',  'vacataires',            'vacataires/VacataireController@index'],
        ['GET',  'vacataires/:id',        'vacataires/VacataireController@show'],
        ['POST', 'vacataires',            'vacataires/VacataireController@store'],
    ],
];
```

### 7.3 Tuto : Créer une fonctionnalité de A à Z

Imaginons qu'on veuille créer l'endpoint `GET /api/vacataires/:id` pour renvoyer un vacataire et ses paiements.

#### Étape 1 : Créer la Resource (`modules/vacataires/resources/VacataireResource.php`)
```php
<?php

namespace modules\vacataires\resources;

use core\Resource;

class VacataireResource extends Resource
{
    public function toArray(): array
    {
        $vacataire = $this->resource;

        return [
            'id'             => $vacataire->PER_ID,
            'statutDossier'  => $vacataire->VAC_STATUT_DOSSIER,
            'personne'       => [
                'nom'    => $vacataire->getPersonne()?->PER_NOM,
                'prenom' => $vacataire->getPersonne()?->PER_PRENOM,
                'email'  => $vacataire->getPersonne()?->PER_MAIL,
            ],
        ];
    }
}
```

#### Étape 2 : Créer le Contrôleur (`modules/vacataires/controllers/VacataireController.php`)
```php
<?php

namespace modules\vacataires\controllers;

use core\Controller;
use core\Resource;
use models\vacataires\Vacataire;
use modules\vacataires\resources\VacataireResource;

class VacataireController extends Controller
{
    public function show(string $id): void
    {
        $vacataire = Vacataire::findById($id);

        if (!$vacataire) {
            Resource::error("Vacataire introuvable", 404);
        }

        (new VacataireResource($vacataire))->send(200);
    }
}
```

#### Étape 3 : Brancher la route (`modules/vacataires/index.php`)
```php
<?php

return [
    'routes' => [
        ['GET', 'vacataires/:id', 'vacataires/VacataireController@show'],
    ],
];
```

Teste dans ton navigateur ou Postman sur `http://localhost:8000/back/vacataires/PER_001` :  
Tadaa ! 🚀 Un JSON propre, sécurisé et rapide.

---

## 8. Bonnes pratiques & pièges qui font perdre 2h

- ⚠️ **Paramètres d'URL = `string`** : Quand une route capture `:id`, le contrôleur reçoit une chaîne de caractères `"42"`. Pense à convertir en `(int)` si tu manipules un entier numérique !
- ⚠️ **`exit` après `send()` et `error()`** : C'est conçu pour t'éviter d'envoyer du contenu parasite. Ne place jamais de code critique après ces méthodes.
- ⚠️ **`Database` et le namespace** : Si tu es dans un fichier avec un namespace (`namespace modules\xxx;`), tape `\Database::getInstance()` ou ajoute `use Database;` en haut de ton fichier.
- ⚠️ **Envoi de cookies / sessions** : Ne jamais faire de `echo` ou afficher du HTML avant de manipuler les cookies ou la session, sinon PHP hurlera *"Headers already sent"*.
- ⚠️ **Pas de `SELECT *` exposé au client** : Passe toujours par une `Resource` pour ne jamais faire fuiter de colonnes sensibles (`PER_PASSWORD`, etc.).

---

## 9. Annexes et liens utiles

- ⚡ [ESSENTIALS.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/ESSENTIALS.md) : Le condensé rapide pour coder sans attendre.
- 🗄️ [INIT_DB.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INIT_DB.md) : Guide pas-à-pas pour installer MySQL et configurer Laragon / HeidiSQL.
- 🤖 [AGENT.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/AGENT.md) : Spécifications techniques détaillées et règles strictes pour les agents IA.
- 🌐 [Méthodes HTTP](docs/httpreq.png) : Rappel des verbes standards (GET = lecture, POST = création, PUT = modification, DELETE = suppression).
