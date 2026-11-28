# Guide du Développeur — Back-end R310

Bienvenue sur la documentation officielle du back-end du projet **R310**.

Que vous soyez ici pour ajouter une route, brancher une table ou comprendre le flux de réponse JSON, ce guide rassemble l'ensemble des principes d'architecture et des conventions à suivre pour contribuer efficacement au projet.

> **Pressé(e) ?** Pour accéder directement aux commandes, snippets essentiels et règles d'or sans explications détaillées, consultez le pense-bête : [ESSENTIALS.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/ESSENTIALS.md).

---

## Sommaire

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
   - [6.3 Modèles personnalisés pour requêtes complexes](#63-modèles-personnalisés-pour-requêtes-complexes)
7. [Les modules métier (`modules/`)](#7-les-modules-métier-modules)
   - [7.1 Anatomie d'un module](#71-anatomie-dun-module)
   - [7.2 Déclarer des routes dans `index.php`](#72-déclarer-des-routes-dans-indexphp)
   - [7.3 Tuto : Créer une fonctionnalité de A à Z](#73-tuto--créer-une-fonctionnalité-de-a-à-z)
8. [Bonnes pratiques & pièges fréquents](#8-bonnes-pratiques--pièges-fréquents)
9. [Annexes et liens utiles](#9-annexes-et-liens-utiles)

---

## 1. Vue d'ensemble (Le back-end en 2 minutes)

Le back-end est une **API RESTful JSON** développée en **PHP 8.4+** et **MySQL**, basée sur une architecture légère **MRC** (*Model - Resource - Controller*) sans framework externe lourd.

Il est découpé en deux grandes zones :
- **Le noyau (`core/` et `db/`)** : Les fondations communes (routeur, contrôleur parent, gestionnaire PDO, sessions, cookies, réponses JSON).
- **Les modules (`modules/<domaine>/`)** : Là où vit la logique métier (acteurs, scolarité, vacataires, décisions…). C'est ici que s'effectue l'essentiel du développement au quotidien.

### Le voyage d'une requête HTTP

```
                    ┌─────────────────────────┐
                    │ Client (Navigateur/App) │
                    └───────────┬─────────────┘
                                │  GET /back/acteurs/42
                                ▼
                    ┌─────────────────────────┐
                    │       core\Router       │  Résout l'action ciblée
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │    MainController       │  Valide l'entrée
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │     Modèle (POO/SQL)    │  Lit ou écrit en BDD
                    └───────────┬─────────────┘
                                │
                                ▼
                    ┌─────────────────────────┐
                    │     core\Resource       │  Nettoie et formate en JSON
                    └───────────┬─────────────┘
                                │  {"status":200, "data":{...}}
                                ▼
                    ┌─────────────────────────┐
                    │     Client final        │
                    └─────────────────────────┘
```

---

## 2. Démarrage rapide

### Étape 1 : Le fichier `.env`
Dupliquez le fichier `.env.example` en `.env` dans le dossier `back/` et configurez vos accès MySQL locaux :
```ini
DB_HOST=localhost
DB_PORT=3306
DB_NAME=r310_db
DB_CHARSET=utf8mb4
DB_USER=root
DB_PASS=
DB_AUTO_MIGRATE=true
```

> Pour les détails pas-à-pas avec captures d'écran sur Laragon ou HeidiSQL, consultez [INIT_DB.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INIT_DB.md).

### Étape 2 : Lancer le serveur local
À la racine du projet, lancez le serveur intégré PHP :
```bash
php -S localhost:8000 dev-router.php
```

### Étape 3 : Vérifier et appliquer les migrations
Grâce au script CLI dédié :
```bash
# Vérifier l'état des migrations
php back/migrate.php --status

# Appliquer les migrations en attente
php back/migrate.php
```
L'API répond immédiatement sur `http://localhost:8000/back/`.

---

## 3. Structure du projet & Règle d'or

Voici l'organisation générale des fichiers :

```text
back/
├── .env                      # Identifiants de connexion BDD (ne jamais commit)
├── .env.example              # Exemple de configuration
├── autoload.php              # Chargement automatique des classes
├── index.php                 # Point d'entrée unique de l'API
├── migrate.php               # Outil CLI pour gérer les migrations
├── dev-router.php            # Routeur pour le serveur PHP intégré (à la racine)
├── core/                     # LE NOYAU (classes socles communes)
│   ├── Router.php            # Aiguillage des requêtes
│   ├── Controller.php        # Contrôleur parent
│   ├── Model.php             # Modèle parent avec hydratation
│   ├── Resource.php          # Réponses JSON formatées
│   ├── SessionManager.php    # Sessions sécurisées
│   └── CookieManager.php     # Cookies simplifiés
├── db/                       # LA BASE DE DONNÉES
│   ├── Database.php          # Singleton PDO + Transactions + Migrations
│   └── migrations/           # Scripts SQL numérotés (001_MLR3.sql, etc.)
├── models/                   # LES MODÈLES POO (57 tables typées)
│   ├── acteurs/              # Personne, Etudiant, Enseignant, Role...
│   ├── vacataires/           # Vacataire, PaiementVacataire...
│   ├── scolarite/            # Promo, Matiere, Evaluation, Note...
│   ├── apprentissage/        # Apprenti, Stagiaire, Entreprise...
│   ├── decision/             # Decision, CompteRendu, Reunion...
│   ├── vieetudiante/         # Absence, Sanction, Gravite, BDE...
│   ├── poursuiteetude/       # EcoleSup, Ambassade, Parcoursup...
│   └── communication/        # Evenement, Mail, PieceJointe...
└── modules/                  # VOS MODULES MÉTIER
    └── <domaine>/            # ex: acteurs, vacataires, scolarite...
        ├── controllers/      # Contrôleurs spécifiques
        ├── models/           # Modèles spécifiques ou requêtes SQL custom
        ├── resources/        # Resources spécifiques
        └── index.php         # Déclaration des routes du module
```

> **Règle d'or** :  
> **On ne modifie pas `core/` ni `db/` pour ajouter une fonctionnalité métier.**  
> Tout le code applicatif spécifique s'écrit dans `modules/<domaine>/`. Si une modification du noyau semble nécessaire, concertez-vous d'abord avec l'ensemble de l'équipe.

---

## 4. Configuration (`.env`)

Le fichier `back/.env` est chargé automatiquement par `Database.php`. Il alimente `$_ENV` ainsi que `getenv()`.

| Variable | Exemple | Rôle |
| :--- | :--- | :--- |
| `DB_HOST` | `localhost` | Hôte du serveur MySQL |
| `DB_PORT` | `3306` | Port MySQL |
| `DB_NAME` | `r310_db` | Nom de la base de données |
| `DB_CHARSET`| `utf8mb4` | Jeu de caractères (support UTF-8 complet) |
| `DB_USER` | `root` | Nom d'utilisateur MySQL |
| `DB_PASS` | `secret` | Mot de passe MySQL |
| `DB_AUTO_MIGRATE` | `true` | Si `true`, vérifie les migrations à chaque requête via cache instantané |

---

## 5. Le noyau (`core/` et `db/`)

### 5.1 Router (L'aiguilleur du ciel)

Le routeur associe une URL et une méthode HTTP à une action de contrôleur.

```php
$router->addRoute('utilisateurs/:id', 'utilisateurs/UserController@show', 'GET');
```

- **Paramètres dynamiques** : écrivez `:id` ou `{id}`. La valeur capturée est transmise dans le même ordre en paramètre de la méthode de votre contrôleur.
- **Format de l'action** : `<nom-du-module>/<NomDuControleur>@<nomDeLaMethode>`.
- **Erreur 404 automatique** : Si l'URL demandée n'existe pas, le routeur répond avec le code HTTP `404` et le JSON `{"error": "Route introuvable"}`.

### 5.2 Controller (Le chef d'orchestre)

Chaque contrôleur hérite de `core\Controller`. Dès l'instanciation, vous disposez de :
- `$this->session` : l'instance unique de `SessionManager`.
- `$this->cookies` : l'instance unique de `CookieManager`.
- `$this->getInput()` : tableau associatif contenant le JSON envoyé par le client (ou `$_POST` en repli).

```php
namespace modules\acteurs\controllers;

use core\Controller;

class ProfilController extends Controller
{
    public function update(): void
    {
        $body = $this->getInput();
        $nom = $body['nom'] ?? null;
    }
}
```

### 5.3 Database & Transactions

La classe `Database` est un **Singleton** qui gère la connexion PDO unique. On ne fait jamais `new Database()`, mais :
```php
$db = Database::getInstance(); // Ou \Database::getInstance() dans un fichier avec namespace
```

#### Requêtes préparées classiques (dans un Model) :
```php
// SELECT préparé
$stmt = $this->db->prepare("SELECT * FROM TD_PERSONNE WHERE PER_MAIL = ?");
$stmt->execute([$email]);
$utilisateur = $stmt->fetch();

// INSERT préparé
$stmt = $this->db->prepare("INSERT INTO TD_ROLE (ROL_ID, ROL_LIBELLE) VALUES (?, ?)");
$stmt->execute(['ROL_01', 'Administrateur']);
```

#### Transactions atomiques :
Pour enregistrer plusieurs lignes liées de façon indissociable, utilisez `transaction()` :
```php
$db->transaction(function ($db) use ($vacataireId, $montant) {
    $db->prepare("INSERT INTO TD_VACATAIRE ...")->execute([...]);
    $db->prepare("INSERT INTO TD_PAIEMENT_VACATAIRE ...")->execute([...]);
});
```
> En cas d'erreur ou d'exception levée dans la fonction, toutes les opérations sont automatiquement annulées (*rollback*).

### 5.4 Les Migrations (Sans sueurs froides)

Pour modifier le schéma SQL sans intervention manuelle sur chaque machine :

1. Créez un fichier SQL numéroté dans `back/db/migrations/`, par exemple `002_ma_nouvelle_table.sql`.
2. Lancez le script :
   ```bash
   php back/migrate.php
   ```
3. Le script exécute uniquement les nouveaux fichiers et consigne leur application dans la table `migrations`.

> **Performance** : Un fichier cache (`back/db/.migrations_cache`) permet de vérifier que la base est à jour en 0,05 milliseconde sans exécuter de requête SQL superflue.

### 5.5 Resource (La reine du JSON)

Les classes `Resource` séparent la structure de la base du format public exposé au client et garantissent une réponse standardisée :

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

// Pour renvoyer une erreur explicite :
Resource::error("Cet utilisateur n'existe pas", 404);
```

> **Attention (piège classique)** : Les méthodes `send()`, `collection()` et `error()` exécutent un `exit;` en interne. Tout code écrit après ces appels ne sera jamais exécuté.

### 5.6 SessionManager & CookieManager

#### La Session (`$this->session`)
La session PHP est configurée de manière sécurisée dès son initialisation (`httponly`, `samesite=Lax`).
```php
// Enregistrer en session
$this->session->set('user_id', $user->PER_ID);

// Régénérer l'identifiant (indispensable après une authentification réussie)
$this->session->regenerate();

// Récupérer une valeur
$userId = $this->session->get('user_id');

// Message flash (détruit dès la première lecture)
$this->session->flash('info', 'Profil mis à jour');
```

#### Les Cookies (`$this->cookies`)
```php
// Définir un cookie (durée en jours)
$this->cookies->set('theme', 'dark', 30);

// Lire le cookie (désérialisation JSON automatique pour les tableaux)
$theme = $this->cookies->get('theme', 'light');
```

---

## 6. Les modèles de données (`models/`)

### 6.1 Organisation par domaines (8 dossiers)

Toutes les 57 tables du schéma SQL disposent d'un modèle orienté objet pré-généré dans `back/models/` :

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

Chaque modèle POO propose des méthodes de recherche et de navigation relationnelle :

```php
use models\acteurs\Personne;
use models\vacataires\Vacataire;

// 1. Recherche par clé primaire
$personne = Personne::findById('PER_001');
echo $personne->PER_NOM;

// 2. Récupérer toutes les lignes d'une table
$promos = Promo::findAll();

// 3. Navigation relationnelle
$vacataire = Vacataire::findById('PER_001');
if ($vacataire) {
    // Récupérer les paiements associés
    $paiements = $vacataire->getPaiementVacataire();
    
    // Récupérer le dossier vacataire
    $dossier = $vacataire->getDossierVacataire();
}
```

> **Alias universels** : Vous pouvez importer `models\vacataires\Vacataire` ou directement `models\Vacataire`. L'autoloader prend en charge les deux syntaxes.

### 6.3 Modèles personnalisés pour requêtes complexes

Les modèles pré-générés de `back/models/` couvrent les opérations élémentaires et la navigation entre tables. Cependant, les cas métiers avancés nécessitent souvent :
- des jointures multiples (`INNER JOIN`, `LEFT JOIN`),
- des calculs et agrégats (`COUNT`, `SUM`, `AVG`, `GROUP BY`),
- des filtres conditionnels avancés,
- des écritures combinées au sein d'une transaction.

Dans ce cas, créez un **modèle spécifique** dans votre module : `back/modules/<domaine>/models/<Nom>Model.php`.

Déroulez les sections ci-dessous pour voir les patterns d'implémentation recommandés :

<details>
<summary><strong>Cas 1 : Requête de lecture complexe (Jointures multiples & Agrégations)</strong></summary>

Dans cet exemple, on calcule le bilan pédagogique complet d'un enseignant en croisant les matières enseignées, les heures effectuées et les moyennes obtenues par les étudiants évalués.

```php
<?php

namespace modules\scolarite\models;

use core\Model;

class StatEnseignantModel extends Model
{
    /**
     * Calcule le bilan pédagogique complet d'un enseignant.
     *
     * @param string $perId Identifiant de l'enseignant (PER_ID)
     * @return array Liste des lignes agrégées sous forme de tableau associatif
     */
    public function getBilanEnseignant(string $perId): array
    {
        $sql = "
            SELECT 
                P.PER_ID,
                P.PER_NOM,
                P.PER_PRENOM,
                M.MAT_ID,
                M.MAT_LIBELLE,
                COALESCE(SUM(H.HEU_NB_HEURE), 0) AS total_heures,
                COUNT(DISTINCT R.ETU_ID) AS nb_etudiants_evalues,
                ROUND(AVG(R.RES_NOTE), 2) AS moyenne_generale
            FROM TD_PERSONNE P
            INNER JOIN TJ_ENSEIGNER E ON P.PER_ID = E.PER_ID
            INNER JOIN TD_MATIERE M ON E.MAT_ID = M.MAT_ID
            LEFT JOIN TD_HEURE H ON E.ENS_ID = H.ENS_ID
            LEFT JOIN TD_EVALUATION EV ON M.MAT_ID = EV.MAT_ID
            LEFT JOIN TD_RESULTAT R ON EV.EVA_ID = R.EVA_ID
            WHERE P.PER_ID = ?
            GROUP BY P.PER_ID, M.MAT_ID, M.MAT_LIBELLE
            ORDER BY M.MAT_LIBELLE ASC
        ";

        // $this->db hérite de Database et fournit directement l'instance PDO
        $stmt = $this->db->prepare($sql);
        $stmt->execute([$perId]);

        return $stmt->fetchAll();
    }
}
```
</details>

<details>
<summary><strong>Cas 2 : Modèle custom avec typage et hydratation automatique (POO)</strong></summary>

Si vous préférez manipuler un objet fortement typé plutôt qu'un tableau associatif brut, déclarez les propriétés et utilisez la méthode `$this->hydrate($data)` fournie par `core\Model`.

```php
<?php

namespace modules\acteurs\models;

use core\Model;

class SanctionDetailModel extends Model
{
    public string $SAN_ID;
    public string $PER_ID;
    public string $PER_NOM;
    public string $PER_PRENOM;
    public string $GRA_LIBELLE;
    public string $SAN_DATE;
    public string $SAN_STATUT;

    /**
     * Recherche une sanction détaillée avec sa gravité et l'identité de l'étudiant.
     */
    public static function findDetail(string $sanctionId): ?static
    {
        $sql = "
            SELECT 
                S.SAN_ID,
                S.PER_ID,
                P.PER_NOM,
                P.PER_PRENOM,
                G.GRA_LIBELLE,
                S.SAN_DATE,
                S.SAN_STATUT
            FROM TD_SANCTION S
            JOIN TD_PERSONNE P ON S.PER_ID = P.PER_ID
            JOIN TD_GRAVITE G ON S.GRA_ID = G.GRA_ID
            WHERE S.SAN_ID = ?
            LIMIT 1
        ";

        $stmt = \Database::getInstance()->prepare($sql);
        $stmt->execute([$sanctionId]);
        $row = $stmt->fetch();

        // hydrate() renseigne automatiquement les propriétés typées de la classe
        return $row ? (new static())->hydrate($row) : null;
    }
}
```
</details>

<details>
<summary><strong>Cas 3 : Écritures atomiques avec transaction</strong></summary>

Lorsqu'une opération métier doit insérer ou modifier plusieurs tables interdépendantes, isolez l'exécution dans une transaction. Si une seule étape échoue, la totalité des écritures est annulée.

```php
<?php

namespace modules\vacataires\models;

use core\Model;

class GestionVacataireModel extends Model
{
    /**
     * Enregistre un vacataire et initialise sa première tranche de paiement.
     */
    public function creerAvecPremierPaiement(string $perId, float $montant, string $iban): bool
    {
        return $this->db->transaction(function ($db) use ($perId, $montant, $iban) {
            // 1. Insertion du dossier vacataire
            $stmtVac = $db->prepare("
                INSERT INTO TD_VACATAIRE (PER_ID, VAC_IBAN, VAC_STATUT_DOSSIER)
                VALUES (?, ?, 'En attente')
            ");
            $stmtVac->execute([$perId, $iban]);

            // 2. Insertion du premier paiement associé
            $stmtPai = $db->prepare("
                INSERT INTO TD_PAIEMENT_VACATAIRE (PAI_ID, PER_ID, PAI_MONTANT, PAI_DATE)
                VALUES (UUID(), ?, ?, NOW())
            ");
            $stmtPai->execute([$perId, $montant]);

            return true;
        });
    }
}
```
</details>

<details>
<summary><strong>Comment appeler ce modèle dans un Contrôleur et le renvoyer en Resource ?</strong></summary>

L'appel s'effectue dans le contrôleur du module, sans écrire une seule ligne de SQL :

```php
namespace modules\scolarite\controllers;

use core\Controller;
use core\Resource;
use modules\scolarite\models\StatEnseignantModel;

class StatEnseignantController extends Controller
{
    // GET /scolarite/enseignants/:id/bilan
    public function bilan(string $id): void
    {
        $model = new StatEnseignantModel();
        $donnees = $model->getBilanEnseignant($id);

        if (empty($donnees)) {
            Resource::error("Aucune donnée enregistrée pour cet enseignant", 404);
        }

        // Rendu immédiat via une Resource anonyme ou une classe dédiée
        (new class($donnees) extends Resource {
            public function toArray(): array { return $this->resource; }
        })->send(200);
    }
}
```
</details>

---

## 7. Les modules métier (`modules/`)

### 7.1 Anatomie d'un module

Chaque fonctionnalité correspond à un sous-dossier de `back/modules/` :
```text
modules/vacataires/
├── controllers/      # Reçoivent les requêtes et pilotent la réponse
├── models/           # Requêtes SQL métier et modèles custom
├── resources/        # Formatage JSON des données
└── index.php         # Déclaration des routes
```

### 7.2 Déclarer des routes dans `index.php`

Le fichier `index.php` d'un module retourne un tableau contenant la clé `'routes'` :

```php
<?php

return [
    'routes' => [
        // [ Méthode HTTP, URI, 'Module/Contrôleur@méthode' ]
        ['GET',  'vacataires',            'vacataires/VacataireController@index'],
        ['GET',  'vacataires/:id',        'vacataires/VacataireController@show'],
        ['POST', 'vacataires',            'vacataires/VacataireController@store'],
    ],
];
```

### 7.3 Tuto : Créer une fonctionnalité de A à Z

Prenons l'exemple de l'endpoint `GET /back/vacataires/:id` retournant un vacataire et ses coordonnées.

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

#### Étape 3 : Déclarer la route (`modules/vacataires/index.php`)
```php
<?php

return [
    'routes' => [
        ['GET', 'vacataires/:id', 'vacataires/VacataireController@show'],
    ],
];
```

L'endpoint est immédiatement fonctionnel sur `http://localhost:8000/back/vacataires/PER_001`.

---

## 8. Bonnes pratiques & pièges fréquents

- **Paramètres d'URL = chaînes** : Les paramètres capturés via `:id` arrivent sous forme de `string` dans la méthode du contrôleur. Convertissez-les explicitement avec `(int)` si vous attendez un entier.
- **Interruption par `exit` dans `Resource`** : Les méthodes `send()`, `collection()` et `error()` terminent l'exécution du script via `exit;`. Ne placez aucun traitement essentiel après ces appels.
- **Résolution du namespace pour `Database`** : Dans un fichier doté d'un namespace (`namespace modules\...;`), référencez la classe via `\Database::getInstance()` ou déclarez `use Database;` en tête de fichier.
- **En-têtes HTTP et sessions** : N'effectuez aucun `echo` ni affichage de texte avant d'initialiser une session ou de manipuler des cookies, sous peine de déclencher l'erreur *"Headers already sent"*.
- **Jamais de données sensibles dans la réponse** : Utilisez systématiquement une `Resource` pour filtrer les colonnes sensibles (`PER_PASSWORD`, tokens internes, etc.).

---

## 9. Annexes et liens utiles

- [ESSENTIALS.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/ESSENTIALS.md) : Pense-bête synthétique et snippets copier-coller.
- [INIT_DB.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INIT_DB.md) : Guide d'initialisation de MySQL et configuration de la base.
- [AGENT.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/AGENT.md) : Spécifications techniques et invariants pour les agents IA.
- [Méthodes HTTP](docs/httpreq.png) : Aide-mémoire sur les verbes HTTP standards.
