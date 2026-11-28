# ⚡ Points Essentiels — Cheatsheet Back-end R310

Ce document est un **pense-bête rapide** pour coder efficacement sur le back-end sans avoir à relire l'intégralité du guide complet [INDEX.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INDEX.md).

---

## 🧭 Le projet en 30 secondes

- **Architecture** : MRC (*Model - Resource - Controller*) fait maison en PHP 8.4+ / MySQL.
- **Principe** :
  1. Le client tape sur une URL (`/api/...`).
  2. Le `Router` appelle la méthode d'un `Controller`.
  3. Le `Controller` récupère les données via un `Model` (soit les modèles POO existants dans `models/`, soit un modèle SQL custom).
  4. Le résultat est formaté et envoyé en JSON par une `Resource`.
  5. **Terminé !** (la méthode `send()` ou `error()` coupe le script avec `exit`).

---

## 🛑 Les 5 règles d'or (À graver dans le marbre)

1. **Ne touche pas à `core/` ni à `db/`** : Ton code métier va **exclusivement** dans `modules/<ton-domaine>/`.
2. **Zéro SQL dans les Contrôleurs** : Les requêtes SQL vivent dans les classes `Model`.
3. **Zéro injection SQL** : Toujours utiliser `$this->db->prepare()` avec des marqueurs `?` ou `:nom`. Jamais de concaténation de variable dans une requête.
4. **Pas de `echo json_encode()` à la main** : Utilise toujours `Resource` (`(new MonResource($data))->send()`, `MonResource::collection($list)` ou `Resource::error($msg, $code)`).
5. **Ne jamais commiter le fichier `.env`** : Il contient les identifiants de ta base de données locale.

---

## ⌨️ Commandes utiles

```bash
# 🚀 Démarrer le serveur de développement (à la racine du projet)
php -S localhost:8000 dev-router.php

# 📦 Voir l'état des migrations SQL
php back/migrate.php --status

# 🔄 Appliquer les nouvelles migrations SQL en attente
php back/migrate.php

# ⚠️ Réinitialiser complètement la base de données et rejouer toutes les migrations (DEV UNIQUEMENT)
php back/migrate.php --fresh
```

---

## 📋 Snippets Copier-Coller

### 1. Déclarer une route (`modules/<domaine>/index.php`)

```php
<?php

return [
    'routes' => [
        ['GET',  'acteurs',               'acteurs/MainActeursController@index'],
        ['GET',  'acteurs/:id',           'acteurs/MainActeursController@show'],
        ['POST', 'acteurs',               'acteurs/MainActeursController@store'],
        ['GET',  'acteurs/:id/vacataire', 'acteurs/MainActeursController@vacataire'],
    ],
];
```

### 2. Le Contrôleur (`modules/<domaine>/controllers/MonController.php`)

```php
<?php

namespace modules\acteurs\controllers;

use core\Controller;
use core\Resource;
use models\acteurs\Personne;
use modules\acteurs\resources\PersonneResource;

class MonController extends Controller
{
    // GET /acteurs/:id
    public function show(string $id): void
    {
        $personne = Personne::findById($id);

        if (!$personne) {
            Resource::error("Personne introuvable", 404); // Exit automatique ici !
        }

        (new PersonneResource($personne))->send(200); // Exit automatique ici aussi !
    }

    // POST /acteurs
    public function store(): void
    {
        // Récupère le body JSON ou $_POST en tableau associatif
        $input = $this->getInput();

        if (empty($input['nom']) || empty($input['prenom'])) {
            Resource::error("Le nom et le prénom sont requis", 400);
        }

        // Traitement...
        // (new MaResource($nouveau))->send(201);
    }
}
```

### 3. Utiliser les Modèles POO existants (`back/models/`)

Tous les 57 modèles de la base de données sont déjà générés et typés dans `back/models/` :

```php
use models\acteurs\Personne;
use models\vacataires\Vacataire;

// 🔍 Récupérer par ID
$personne = Personne::findById('PER_001');

// 👥 Récupérer tout
$toutes = Personne::findAll();

// 🔗 Navigation orientée objet
$vacataire = Vacataire::findById('PER_001');
if ($vacataire) {
    // Récupérer les paiements associés
    $paiements = $vacataire->getPaiementVacataire();

    // Ou depuis un paiement, retrouver le vacataire
    // $vacataire = $paiement->getVacataire();
}
```

### 4. Modèle personnalisé avec SQL (`modules/<domaine>/models/MonCustomModel.php`)

Si vous avez besoin d'une requête complexe (jointures spécifiques, agrégations) :

```php
<?php

namespace modules\acteurs\models;

use core\Model;

class StatActeurModel extends Model
{
    public function getStatsByRole(): array
    {
        // $this->db est disponible directement (instance unique de Database)
        $sql = "SELECT R.ROL_LIBELLE, COUNT(A.PER_ID) AS total
                FROM TD_ROLE R
                LEFT JOIN TJ_ATTRIBUE A ON R.ROL_ID = A.ROL_ID
                GROUP BY R.ROL_ID";

        return $this->db->query($sql)->fetchAll();
    }
}
```

### 5. La Resource JSON (`modules/<domaine>/resources/MaResource.php`)

Formate les données pour la sortie API (masque les données sensibles comme les mots de passe) :

```php
<?php

namespace modules\acteurs\resources;

use core\Resource;

class PersonneResource extends Resource
{
    public function toArray(): array
    {
        // $this->resource contient soit un tableau associatif, soit une instance de Model
        return [
            'id'       => $this->resource->PER_ID ?? $this->resource['PER_ID'],
            'nom'      => $this->resource->PER_NOM ?? $this->resource['PER_NOM'],
            'prenom'   => $this->resource->PER_PRENOM ?? $this->resource['PER_PRENOM'],
            'email'    => $this->resource->PER_MAIL ?? $this->resource['PER_MAIL'],
            // Ne jamais exposer PER_PASSWORD !
        ];
    }
}
```

### 6. Sessions & Cookies

Disponibles automatiquement dans n'importe quel contrôleur via `$this->session` et `$this->cookies` :

```php
// --- SESSION ---
$this->session->set('user_id', $user->PER_ID);
$userId = $this->session->get('user_id');
$this->session->regenerate(); // ⚠️ Toujours après une connexion réussie

// Messages flash (lu une seule fois puis détruit)
$this->session->flash('info', 'Bienvenue !');
$msg = $this->session->flash('info');

// --- COOKIES ---
$this->cookies->set('theme', 'dark', 30); // 30 jours, HttpOnly
$theme = $this->cookies->get('theme', 'light');
```

---

## 🗂️ Carte des 8 dossiers de Modèles (`back/models/`)

| Dossier | Modèles principaux | Exemples d'usage |
| :--- | :--- | :--- |
| `acteurs/` | `Personne`, `Etudiant`, `Enseignant`, `Administration`, `Ambassadeur`, `Representant`, `Role`, `Attribue` | Utilisateurs, rôles et authentification |
| `vacataires/` | `Vacataire`, `PaiementVacataire`, `DossierVacataire`, `Checklist`, `EtapeChecklist` | Gestion financière et RH des vacataires |
| `scolarite/` | `Promo`, `Groupe`, `Matiere`, `Heure`, `Enseigner`, `Evaluation`, `TypeEval`, `Resultat`, `Jury` | Notes, promos, matières et créneaux |
| `apprentissage/` | `Apprenti`, `Stagiaire`, `Entreprise` | Suivi alternance, stages et tuteurs |
| `decision/` | `Decision`, `TypeDecision`, `CompteRendu`, `Reunion`, `Participe`, `Keyword`, `JournalDecision` | Délibérations, réunions, décisions officielles |
| `vieetudiante/` | `Absence`, `Amenagement`, `Sanction`, `Gravite`, `RdvSse`, `CrousFermeture`, `InfoBde` | Vie sur le campus, santé et discipline |
| `poursuiteetude/` | `EcoleSup`, `Ambassade`, `Souhait`, `Inclus`, `QuestionAmbassadeur`, `FicheParcoursup` | Orientation post-DUT/BUT, salons |
| `communication/` | `Evenement`, `TemplateMail`, `PieceJointe`, `Joindre`, `Destiner`, `QuestionDocinfo` | Mails types, agendas, questions/réponses |

> 💡 **Alias pratiques** : Les modèles sont accessibles soit par leur sous-dossier (`use models\acteurs\Personne;`), soit directement à la racine (`use models\Personne;`).

---

## 🚦 Codes HTTP de Référence

- `200 OK` : Lecture / Mise à jour réussie.
- `201 Created` : Entité créée avec succès (ex: après un POST).
- `400 Bad Request` : Paramètres manquants ou invalides (`Resource::error('Champ requis', 400)`).
- `401 Unauthorized` : Utilisateur non authentifié.
- `403 Forbidden` : Utilisateur connecté mais droits insuffisants.
- `404 Not Found` : Ressource introuvable.
- `500 Internal Server Error` : Crash inattendu, exception PDO non gérée.

---

📖 **Pour approfondir** : Consultez le guide complet et détaillé dans [INDEX.md](file:///C:/Users/gabidut/WebstormProjects/r310-project/back/INDEX.md).
