# Projet R3.10

> Ce projet est un projet de développement logiciel pour le cours R3.10. Il a pour objectif de créer une application web permettant la gestion simplifiée des différents services du Campus 3.

## Organisation du projet
### Architecture des fichiers
Ce projet fonctionne dans le format Back-End et Front-End séparé.

Le Back-End est développé via PHP et un framework MRC (Model Response Controller) pour la gestion des requêtes et des réponses.
Le Front-End est développé via HTML, CSS et JavaScript pour l'interface utilisateur.

L'architecture des fichiers est organisée de la manière suivante :

```
r310-project/
├── backend/
│   ...Todo...
│
├── frontend/
│   ...Todo...
│
├── shared/
│   ...Todo mais contiendra les types construits.
│
├── .gitignore
├── README.md
```
### Gestion GIT

Concernant la gestion git, l'organisation des branches s'effectue ainsi :

#### Principales : 

main : branche principale contenant la version stable du projet.
development : branche de développement où les nouvelles fonctionnalités sont intégrées et testées avant d'être fusionnées dans la branche principale.

#### Core : 

core/
core/front
core/back


#### Fonctionnalités spécifiques :

[nom-fonctionnalité] : branche avec la fonctionnalité en cours de développement.<br>
[nom-fonctionnalité]/fix: branche de correction de bugs spécifiques.<br>
[nom-fonctionnalité]/feature : branche de développement de nouvelles fonctionnalités spécifiques.<br>
[nom-fonctionnalité]/refactor : branche de refactorisation de code spécifiques.<br>