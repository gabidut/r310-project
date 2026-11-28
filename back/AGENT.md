# 🤖 AI Agent Technical Specifications & Coding Protocol — Back-end R310

> **Target Audience**: AI Coding Assistants, LLMs, and Autonomous Subagents interacting with the `r310-project/back` codebase.
> **Language**: PHP 8.4+ (Strict typing, Modern POO, Singletons, PDO MySQL).
> **Architecture Pattern**: Custom MRC (Model - Resource - Controller).

---

## 1. System Context & Execution Environment

The back-end is a lightweight, zero-dependency RESTful JSON API written in modern PHP.
- **Root Directory**: `back/` (accessed via web server at `/back/` or via CLI router `dev-router.php`).
- **PHP Version Target**: `8.4+`.
- **Database Engine**: MySQL / MariaDB (InnoDB, `utf8mb4`).
- **Autoloader**: Native PSR-like autoloader registered in `back/autoload.php` (supports PSR-4-like namespaces `models\<domain>\<Class>`, module structures `modules/<module>/...`, and fallback short classnames).

---

## 2. Strict Invariants & Non-Negotiable Constraints

AI agents MUST comply with the following invariants on every code generation or modification task:

1. **NO MODIFICATION OF `core/` OR `db/`**:
   - Unless explicitly tasked by the user, **NEVER** edit files inside `back/core/` (`Router.php`, `Controller.php`, `Model.php`, `Resource.php`, `SessionManager.php`, `CookieManager.php`) or `back/db/Database.php`.
   - All domain features, new business logic, and endpoints must be placed exclusively under `back/modules/<module_name>/`.

2. **ABSOLUTE SEPARATION OF CONCERNS**:
   - **Controllers** (`modules/<module>/controllers/*Controller.php`): Handle input validation, call domain models, and delegate JSON responses to Resources. **NEVER** write raw SQL queries inside a Controller.
   - **Models** (`models/*/*.php` or `modules/<module>/models/*Model.php`): Execute SQL queries via `$this->db` or navigate typed OOP entities. **NEVER** generate HTTP responses inside a Model.
   - **Resources** (`modules/<module>/resources/*Resource.php`): Transform, format, and redact data (hide passwords/salts) for output. **NEVER** execute SQL queries or business computations inside a Resource.

3. **PREPARED STATEMENTS ONLY (Zero Injection Vulnerability)**:
   - **NEVER** concatenate user variables into SQL queries (e.g., `WHERE id = " . $id` is strictly prohibited).
   - **ALWAYS** use PDO prepared statements: `$this->db->prepare('SELECT ... WHERE id = ?')->execute([$id]);`.

4. **HTTP RESPONSE PROTOCOL & TERMINATION**:
   - **NEVER** use `echo json_encode(...)` or `die(...)` directly.
   - **ALWAYS** use `core\Resource` methods:
     - Single entity: `(new CustomResource($entity))->send(200);`
     - Collection: `CustomResource::collection($entityList, 200);`
     - Errors: `\core\Resource::error("Descriptive message", 400);`
   - **CRITICAL WARNING**: `Resource::respond` calls `exit;`. Any statements placed after `send()`, `collection()`, or `error()` are completely unreachable.

5. **SINGLETON ACCESS**:
   - `Database`, `SessionManager`, and `CookieManager` are strict singletons.
   - **NEVER** instantiate via `new Database()`.
   - **ALWAYS** retrieve via `\Database::getInstance()`, `\core\SessionManager::getInstance()`, `\core\CookieManager::getInstance()`.
   - Inside Controllers: access via `$this->session` and `$this->cookies`.
   - Inside Models: access PDO via `$this->db`.

---

## 3. Directory Layout & Architecture

```text
back/
├── .env                      # Database credentials & environment config (ignored in Git)
├── .env.example              # Template config
├── autoload.php              # SPL autoloader & module manifest aggregator
├── index.php                 # HTTP Front Controller & router dispatcher
├── migrate.php               # CLI Migration runner (--status, --fresh, etc.)
├── core/                     # Abstract foundational infrastructure
│   ├── Router.php            # URI dispatcher & regex parameter parser
│   ├── Controller.php        # Abstract base controller (session, cookies, getInput)
│   ├── Model.php             # Abstract base model (PDO instance, reflection hydrator)
│   ├── Resource.php          # Abstract base JSON response formatter
│   ├── SessionManager.php    # Singleton session handler
│   └── CookieManager.php     # Singleton cookie handler
├── db/                       # Database layer
│   ├── Database.php          # Singleton PDO connection & migration engine
│   ├── .migrations_cache     # Fast filesystem cache for instant migration status check
│   └── migrations/           # Versioned SQL migrations (001_MLR3.sql, etc.)
├── models/                   # 57 Pre-generated, fully-typed Domain Models
│   ├── acteurs/              # Personne, Etudiant, Enseignant, Role, Attribue...
│   ├── vacataires/           # Vacataire, PaiementVacataire, DossierVacataire...
│   ├── scolarite/            # Promo, Groupe, Matiere, Heure, Evaluation, Resultat...
│   ├── apprentissage/        # Apprenti, Stagiaire, Entreprise
│   ├── decision/             # Decision, CompteRendu, Reunion, Participe, Keyword...
│   ├── vieetudiante/         # Absence, Sanction, Gravite, Amenagement, InfoBde...
│   ├── poursuiteetude/       # EcoleSup, Ambassade, Souhait, QuestionAmbassadeur...
│   └── communication/        # Evenement, TemplateMail, PieceJointe, Destiner...
└── modules/                  # Modular Business Domains
    └── <domain>/             # e.g., 'acteurs', 'vacataires', 'scolarite'
        ├── controllers/      # Named XxxController.php extending core\Controller
        ├── models/           # Domain-specific SQL queries extending core\Model
        ├── resources/        # Named XxxResource.php extending core\Resource
        └── index.php         # Manifest file returning ['routes' => [...]]
```

---

## 4. Pre-Generated Domain Models Reference (`back/models/`)

All 57 SQL tables from `001_MLR3.sql` have corresponding typed PHP classes inside `back/models/<subfolder>/`:

### 4.1 Namespaces & Aliases
- Primary namespace: `namespace models\<subfolder>;` (e.g., `namespace models\acteurs;`).
- Registered class alias: `models\<ClassName>` points directly to `models\<subfolder>\<ClassName>`.
- Both import styles are valid:
  ```php
  use models\acteurs\Personne; // Fully qualified
  use models\Personne;         // Short alias (supported automatically)
  ```

### 4.2 Standard Method Contract on Domain Models
Every domain model class implements:
1. `public static function findById(string|int $id): ?static`
   - Retrieves a single row by its primary key, hydrates properties via `ReflectionProperty`, returns null if not found.
2. `public static function findAll(): array`
   - Returns an array of hydrated model instances for all records in the table.
3. `public static function getFrom<SourceModel>(<SourceModel> $source): array|static|null`
   - Contextual static query (e.g., `PaiementVacataire::getFromVacataire(Vacataire $vacataire)`).
4. `public function get<TargetModel>(): array|object|null`
   - OOP navigation getter across foreign keys (e.g., `$vacataire->getPaiementVacataire()`, `$paiement->getVacataire()`).

---

## 5. Routing Specification

Modules declare routes in `back/modules/<module>/index.php`. The file must return an array with key `'routes'`.

### Route Definition Syntax
```php
<?php

return [
    'routes' => [
        // [ HTTP_METHOD, URI_PATTERN, CONTROLLER_ACTION ]
        ['GET',    'vacataires',            'vacataires/VacataireController@index'],
        ['GET',    'vacataires/:id',        'vacataires/VacataireController@show'],
        ['POST',   'vacataires',            'vacataires/VacataireController@store'],
        ['PUT',    'vacataires/:id',        'vacataires/VacataireController@update'],
        ['DELETE', 'vacataires/:id',        'vacataires/VacataireController@delete'],
    ],
];
```

### Route Rules:
- **Methods**: `'GET'`, `'POST'`, `'PUT'`, `'DELETE'`, or `'ANY'`.
- **Dynamic Parameters**: Defined with `:paramName` or `{paramName}`.
- **Dispatching**: Captured values are passed **positionally** to the controller method:
  `'vacataires/:id/heures/:month'` -> `public function hours(string $id, string $month): void`
- **Type Casting**: Injected route parameters are strings. Cast explicitly if required: `(int) $id`.

---

## 6. Canonical Implementation Templates

### 6.1 Controller Template
```php
<?php

namespace modules\vacataires\controllers;

use core\Controller;
use core\Resource;
use models\vacataires\Vacataire;
use modules\vacataires\resources\VacataireResource;

class VacataireController extends Controller
{
    // GET /vacataires/:id
    public function show(string $id): void
    {
        $vacataire = Vacataire::findById($id);

        if (!$vacataire) {
            Resource::error("Vacataire introuvable avec l'identifiant {$id}", 404);
        }

        (new VacataireResource($vacataire))->send(200);
    }

    // POST /vacataires
    public function store(): void
    {
        $input = $this->getInput();

        if (empty($input['per_id'])) {
            Resource::error("Le champ 'per_id' est obligatoire", 400);
        }

        // Delegate to a custom module model or transaction...
        // Return 201 Created on success
    }
}
```

### 6.2 Custom SQL Model Template
```php
<?php

namespace modules\vacataires\models;

use core\Model;

class VacataireStatsModel extends Model
{
    public function getPaymentSummary(string $vacataireId): array
    {
        $sql = "SELECT COUNT(*) as nb_paiements, COALESCE(SUM(PAI_MONTANT), 0) as total_verse
                FROM TD_PAIEMENT_VACATAIRE
                WHERE PER_ID = ?";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([$vacataireId]);
        return $stmt->fetch() ?: ['nb_paiements' => 0, 'total_verse' => 0];
    }
}
```

### 6.3 Resource Template
```php
<?php

namespace modules\vacataires\resources;

use core\Resource;

class VacataireResource extends Resource
{
    public function toArray(): array
    {
        /** @var \models\vacataires\Vacataire $vacataire */
        $vacataire = $this->resource;

        return [
            'id'             => $vacataire->PER_ID,
            'statutDossier'  => $vacataire->VAC_STATUT_DOSSIER,
            'personne'       => [
                'nom'    => $vacataire->getPersonne()?->PER_NOM,
                'prenom' => $vacataire->getPersonne()?->PER_PRENOM,
                'email'  => $vacataire->getPersonne()?->PER_MAIL,
            ],
            'paiements'      => array_map(function ($p) {
                return [
                    'id'      => $p->PAI_ID,
                    'montant' => (float) $p->PAI_MONTANT,
                    'date'    => $p->PAI_DATE,
                ];
            }, $vacataire->getPaiementVacataire()),
        ];
    }
}
```

---

## 7. Database Migrations & CLI Protocol

- Location of migration scripts: `back/db/migrations/XXX_name.sql`.
- Migration numbering: `001_`, `002_`, `003_` etc.
- Ingestion mechanism: Handled by `db\Database::migrate()`.
- Optimizations: `Database::checkMigrations()` evaluates directory signature against `back/db/.migrations_cache`.
- Auto-migration mode: Activated if `DB_AUTO_MIGRATE=true` in `.env`.

### CLI Tool Commands:
```bash
php back/migrate.php           # Applies all unapplied migration files
php back/migrate.php --status  # Displays applied vs pending migrations
php back/migrate.php --fresh   # Wipes all tables and replays all migrations (DEV ONLY)
```

### Writing New Migrations:
- Write valid MariaDB / MySQL DDL syntax.
- Use `IF NOT EXISTS` for table/index creation.
- Use `INSERT IGNORE INTO` or `ON DUPLICATE KEY UPDATE` when seeding initial data to guarantee idempotence.

---

## 8. HTTP Status Codes & Error Formatting

All error responses sent via `Resource::error($message, $statusCode)` strictly emit:
```json
{
  "status": 404,
  "message": "Entité introuvable"
}
```

Standard codes to emit:
- `200 OK`: Successful read or update.
- `201 Created`: Successful resource creation via `POST`.
- `400 Bad Request`: Missing mandatory parameters, validation failure.
- `401 Unauthorized`: Authentication required or invalid credentials.
- `403 Forbidden`: Authenticated user lacks permission.
- `404 Not Found`: Resource or route does not exist.
- `500 Internal Server Error`: Unexpected database failure or uncaught runtime exception.

---

## 9. AI Agent Step-by-Step Task Workflow

When instructed to implement a new endpoint or feature:

1. **Verify Existing Models**:
   - Check `back/models/<domain>/` to see if the required tables and navigation methods already exist.
   - Do NOT reinvent models that already exist in `back/models/`.

2. **Create/Update Module Files**:
   - Create or update `back/modules/<module>/controllers/<Name>Controller.php`.
   - Create or update `back/modules/<module>/resources/<Name>Resource.php`.
   - If complex custom aggregation SQL is required, create `back/modules/<module>/models/<Name>Model.php`.

3. **Register Route**:
   - Add the route tuple `['METHOD', 'uri', 'module/Controller@action']` to `back/modules/<module>/index.php`.

4. **Self-Verification**:
   - Ensure imports (`use`) match the actual namespaces.
   - Confirm all user inputs (`getInput()` or route parameters) are validated before query execution.
   - Confirm no direct `echo` or `die` is used.
