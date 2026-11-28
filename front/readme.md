# Front-End (SPA) - Projet R3.10

Application Single Page Application (SPA) en JavaScript vanilla, HTML et CSS, connectée à l'API PHP du back-end.

## 1. Démarrage

### Option A : ViteJS (développement recommandé)
1. Dans un terminal, lancez le serveur back-end :
   ```bash
   php -S localhost:8000 -t back
   ```
2. Dans un second terminal, lancez le serveur front :
   ```bash
   cd front
   npm install
   npm run dev
   ```
   *Vite relaie automatiquement les requêtes vers `http://localhost:8000` via son proxy.*

### Option B : Apache / Nginx / XAMPP
Placez le dossier du projet dans le répertoire de votre serveur web (ex: `htdocs` ou `www`).
L'URL de l'API s'adapte automatiquement au sous-dossier (ex: `http://localhost/r310-project/back`).

---

## 2. Renseigner un module (`front/js/modules/<nom>/module.js`)

Chaque fonctionnalité possède son propre dossier dans `front/js/modules/<nom>/` avec son fichier `module.js` :

```javascript
import Route from "../../router/route.js";
import Module from "../module.js";

export default class ModuleExemple extends Module {
    constructor() {
        super("ExempleModule"); // Génère automatiquement l'API window.apiHelper.exemple

        // 1. Déclarer vos routes SPA
        this.routes = [
            new Route("/exemple", `${Route.LOCAL_MODULE_PATH_INDICATOR}/views/index.html`, ['navbar']),
        ];

        // 2. Déclarer vos requêtes API spécifiques au module
        this.defineApi({
            getStats() {
                return this.get("stats");
            }
        });
    }
}
```

---

## 3. Exemple de vue HTML : récupérer l'utilisateur courant

Créez un fichier dans `views/profil.html` au sein de votre module :

```html
<!doctype html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Profil</title>
</head>
<body>
    <div id="profil-container">Chargement...</div>

    <script type="module">
        (async () => {
            const container = document.getElementById("profil-container");

            // Récupère l'utilisateur en session sans bloc try/catch obligatoire
            const { data: user, ok, error } = await window.apiHelper.safe(() => 
                window.apiHelper.get("auth/me")
            );

            if (!ok || !user) {
                container.innerHTML = `<p>Non connecté (${error?.message || "Erreur"})</p>`;
                return;
            }

            container.innerHTML = `
                <h2>Bienvenue ${user.prenom} ${user.nom}</h2>
                <p>Identifiant : ${user.id}</p>
                <p>Rôle : ${user.role}</p>
            `;
        })();
    </script>
</body>
</html>
```

---

## 4. Utilisation de `window.apiHelper`

Disponible globalement dans la console ou dans vos scripts :

```javascript
// Requête sur un module
const data = await window.apiHelper.acteurs.get();

// Exécuter une requête métier indexée (GET /back/acteurs/query/1)
const queryRes = await window.apiHelper.acteurs.query(1);

// Appel direct ou sécurisé sans bloc try/catch
const { data: user, ok } = await window.apiHelper.safe(() => window.apiHelper.get("auth/me"));

// Redéfinir manuellement l'URL de l'API si nécessaire
window.apiHelper.setBaseUrl("http://localhost:8000", true);
```

---

## 5. Composants UI (Boutons, Icônes & Champs de texte)

Une bibliothèque de composants CSS conformes aux designs SVG du projet et compatible avec [Bootstrap Icons](https://icons.getbootstrap.com/) est disponible dans `front/css/`.

Consultez le guide complet des classes CSS et exemples d'intégration :
👉 **[Documentation des composants UI](README-UI.md)** (ou dans [front/css/README.md](css/README.md)).
