# Système UI & Composants CSS - Projet R3.10

Ce guide répertorie l'ensemble des classes CSS, des variantes et des exemples HTML pour les **boutons**, les **icônes** et les **zones d'entrée de texte**, fidèlement basés sur les designs SVG du projet (`simple-button.svg`, `icon-button.svg` et `Zones de texte.svg`).

Les icônes s'appuient sur [Bootstrap Icons](https://icons.getbootstrap.com/).

---

## 1. Intégration dans vos pages / vues HTML

Les styles sont centralisés dans `front/css/main.css` qui importe automatiquement :
- `bootstrap-icons` (icônes vectorielles)
- `variables.css` (tokens de couleur, rayons, hauteurs)
- `buttons.css` (boutons, variantes, tailles, états)
- `inputs.css` (zones de texte, labels, icônes, validations)

Dans une vue HTML ou dans `index.html` :
```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
<link rel="stylesheet" href="css/main.css" />
```

---

## 2. Boutons (`.btn`)

### Variantes de style

| Classe CSS | Description | Couleur de fond | Bordure / Focus |
|---|---|---|---|
| `.btn-primary` | Bouton principal | `#1E5250` (Teal foncé) | Ring `#779490` |
| `.btn-secondary` ou `.btn-outline` | Bouton contour / secondaire | `#EFEFEF` | Bordure `#1E5250` |
| `.btn-tertiary` ou `.btn-light` | Bouton tertiaire / neutre | `#E4E2E2` | Ring `#1E5250` |
| `.btn-ghost` | Bouton fantôme / transparent | `transparent` | Bordure `#1E5250` au focus |
| `.btn-danger` | Bouton d'action destructrice | `#D13627` (Rouge) | Ring `#C0291B` |

### Tailles de bouton

| Classe CSS | Hauteur | Rayon (`border-radius`) | Rembourrage |
|---|---|---|---|
| `.btn-sm` | `32px` | `6px` | `0 12px` |
| `.btn-md` *(ou `.btn` seul)* | `40px` | `8px` | `0 16px` |
| `.btn-lg` | `48px` | `10px` | `0 20px` |

### Exemples HTML de boutons simples

```html
<!-- Variantes standard -->
<button type="button" class="btn btn-primary">Enregistrer</button>
<button type="button" class="btn btn-secondary">Annuler</button>
<button type="button" class="btn btn-tertiary">Détails</button>
<button type="button" class="btn btn-ghost">Ignorer</button>
<button type="button" class="btn btn-danger">Supprimer</button>

<!-- Tailles -->
<button type="button" class="btn btn-primary btn-sm">Petit (32px)</button>
<button type="button" class="btn btn-primary btn-md">Moyen (40px)</button>
<button type="button" class="btn btn-primary btn-lg">Grand (48px)</button>

<!-- État désactivé -->
<button type="button" class="btn btn-primary" disabled>Désactivé</button>
```

---

## 3. Boutons avec icônes (Bootstrap Icons)

Pour insérer une icône dans un bouton, utilisez la balise `<i class="bi bi-<nom>"></i>`. L'espacement et l'alignement vertical sont gérés automatiquement via Flexbox.

### Boutons avec texte et icône (gauche ou droite)

```html
<!-- Icône à gauche -->
<button type="button" class="btn btn-primary">
    <i class="bi bi-plus-lg"></i>
    <span>Créer un module</span>
</button>

<!-- Icône à droite -->
<button type="button" class="btn btn-secondary">
    <span>Suivant</span>
    <i class="bi bi-arrow-right"></i>
</button>

<!-- Danger avec icône de corbeille -->
<button type="button" class="btn btn-danger">
    <i class="bi bi-trash"></i>
    <span>Supprimer</span>
</button>
```

### Boutons icône seule (`.btn-icon`)

Les boutons carrés/circulaires pour actions compactes (éditer, filtrer, fermer) utilisent la classe `.btn-icon` :

```html
<!-- Icône seule petite (32x32px) -->
<button type="button" class="btn btn-primary btn-icon btn-sm" aria-label="Favori">
    <i class="bi bi-star-fill"></i>
</button>

<!-- Icône seule moyenne (40x40px) -->
<button type="button" class="btn btn-secondary btn-icon" aria-label="Rechercher">
    <i class="bi bi-search"></i>
</button>

<!-- Icône seule grande (48x48px) -->
<button type="button" class="btn btn-tertiary btn-icon btn-lg" aria-label="Paramètres">
    <i class="bi bi-gear"></i>
</button>

<!-- Icône seule danger -->
<button type="button" class="btn btn-danger btn-icon" aria-label="Supprimer">
    <i class="bi bi-trash"></i>
</button>
```

---

## 4. Zones de saisie de texte (`Zones de texte.svg`)

Les champs reprennent les spécifications exactes du SVG :
- Fond gris clair `#E4E2E2` (survol : `#D5D4D4`)
- Bordure `#C5C5C5` (1px)
- Focus : bordure `#1E5250` avec anneau 1px
- Texte de saisie : `#121211`
- Placeholder : `#ACACAC`

### Structure de base (`.form-group`, `.form-label`, `.form-control`)

```html
<div class="form-group">
    <label for="username" class="form-label">Nom d'utilisateur</label>
    <input type="text" id="username" class="form-control" placeholder="Entrez votre nom..." />
    <span class="form-text">Ce nom sera affiché publiquement.</span>
</div>
```

### Tailles de champ de saisie

```html
<!-- Petit (32px) -->
<input type="text" class="form-control form-control-sm" placeholder="Champ compact (32px)" />

<!-- Standard (40px) -->
<input type="text" class="form-control" placeholder="Champ standard (40px)" />

<!-- Grand (48px) -->
<input type="text" class="form-control form-control-lg" placeholder="Grand champ (48px)" />
```

### Zone de texte multilignes (Textarea)

```html
<div class="form-group">
    <label for="description" class="form-label">Description</label>
    <textarea id="description" class="form-control" rows="4" placeholder="Votre message..."></textarea>
</div>
```

---

## 5. Champs avec icônes intégrées (`.input-icon-group`)

Utilisez `.input-icon-group` pour intégrer une icône à l'intérieur de l'input :

### Icône à gauche (ex: recherche)

```html
<div class="input-icon-group">
    <i class="bi bi-search input-icon-left"></i>
    <input type="search" class="form-control" placeholder="Rechercher un élément..." />
</div>
```

### Icône à droite (ex: action ou étoile de favori)

```html
<div class="input-icon-group">
    <input type="text" class="form-control" placeholder="Saisir une note..." />
    <i class="bi bi-star input-icon-right"></i>
</div>
```

### Champ avec action cliquable (ex: afficher/masquer le mot de passe)

```html
<div class="input-icon-group">
    <i class="bi bi-lock input-icon-left"></i>
    <input type="password" id="pwd" class="form-control" placeholder="Mot de passe" />
    <button type="button" class="input-icon-right input-icon-action" id="toggle-pwd" aria-label="Afficher le mot de passe">
        <i class="bi bi-eye"></i>
    </button>
</div>
```

---

## 6. États de validation (Erreur et Succès)

Conformes aux bordures rouge `#D13627` et verte `#28B870` du SVG :

### Champ en erreur (`.is-invalid` ou conteneur `.has-error`)

```html
<div class="form-group has-error">
    <label for="email" class="form-label">Adresse email</label>
    <input type="email" id="email" class="form-control is-invalid" value="adresse-invalide" />
    <div class="invalid-feedback">
        <i class="bi bi-exclamation-circle-fill"></i>
        <span>Veuillez renseigner une adresse email valide.</span>
    </div>
</div>
```

### Champ valide (`.is-valid` ou conteneur `.has-success`)

```html
<div class="form-group has-success">
    <label for="pseudo" class="form-label">Pseudo</label>
    <input type="text" id="pseudo" class="form-control is-valid" value="gabi_dev" />
    <div class="valid-feedback">
        <i class="bi bi-check-circle-fill"></i>
        <span>Ce pseudo est disponible.</span>
    </div>
</div>
```

### Champ désactivé

```html
<div class="form-group">
    <label class="form-label">Identifiant immuable</label>
    <input type="text" class="form-control" value="ID-987456" disabled />
</div>
```

---

## 7. Exemple complet d'un formulaire type

```html
<form class="my-form">
    <!-- Groupe avec icône gauche -->
    <div class="form-group">
        <label for="user-email" class="form-label">Courriel professionnel</label>
        <div class="input-icon-group">
            <i class="bi bi-envelope input-icon-left"></i>
            <input type="email" id="user-email" class="form-control" placeholder="nom@domaine.fr" required />
        </div>
    </div>

    <!-- Groupe avec icône droite interactive -->
    <div class="form-group">
        <label for="user-pass" class="form-label">Mot de passe</label>
        <div class="input-icon-group">
            <i class="bi bi-key input-icon-left"></i>
            <input type="password" id="user-pass" class="form-control" placeholder="••••••••" required />
            <button type="button" class="input-icon-right input-icon-action" title="Afficher">
                <i class="bi bi-eye"></i>
            </button>
        </div>
    </div>

    <!-- Barre d'actions -->
    <div style="display: flex; gap: 12px; margin-top: 20px;">
        <button type="submit" class="btn btn-primary">
            <i class="bi bi-check2"></i>
            <span>Se connecter</span>
        </button>
        <button type="reset" class="btn btn-secondary">
            Annuler
        </button>
    </div>
</form>
```
