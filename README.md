# P3 — Entraînez-vous avec SQL et créez votre BDD

## Présentation du projet

Ce projet a été réalisé dans le cadre du parcours **Data Engineer** d’OpenClassrooms.

L’objectif est de concevoir et d’exploiter une base de données relationnelle à partir de données immobilières. Le projet se place dans le contexte de **Laplace Immo**, un réseau national d’agences immobilières en France souhaitant mieux exploiter ses données pour analyser le marché immobilier et identifier les zones les plus dynamiques.

Le projet correspond à un **Proof of Concept (POC)** utilisant les données du premier semestre 2020. L’objectif est de valider la faisabilité d’une base de données immobilière et de produire des analyses SQL utiles à la prise de décision.

---

## Contexte métier

Laplace Immo souhaite se différencier dans un marché immobilier concurrentiel grâce à une meilleure exploitation de la donnée.

Le besoin métier est de créer une base de données permettant de :

* centraliser les données immobilières et géographiques ;
* structurer les transactions immobilières ;
* analyser les prix au mètre carré ;
* identifier les régions, départements et communes les plus dynamiques ;
* répondre à des questions métier à l’aide de requêtes SQL.

Le POC se limite au **premier semestre 2020**. Si la solution est validée, elle pourrait être généralisée avec des données historiques supplémentaires.

---

## Objectifs du projet

Les objectifs principaux du projet sont les suivants :

1. Étudier les fichiers de données fournis.
2. Créer un dictionnaire des données.
3. Concevoir un modèle relationnel normalisé.
4. Créer une base de données relationnelle.
5. Charger les données dans les tables.
6. Écrire des requêtes SQL pour répondre aux besoins métier.
7. Analyser les résultats obtenus.
8. Présenter les conclusions et recommandations.

---

## Données utilisées

Le projet utilise trois sources principales :

| Fichier                                | Description                                                                                                                       |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `donnees_communes.xlsx`                | Données sur les communes, leur population et certaines informations géographiques                                                 |
| `fr-esr-referentiel-geographique.xlsx` | Référentiel géographique contenant les régions et départements                                                                    |
| `Valeurs-foncières.xlsx`               | Données de transactions immobilières, comprenant les valeurs foncières, les surfaces, les types de biens et les dates de mutation |

Ces fichiers permettent de relier les transactions immobilières aux communes, départements et régions.

Les fichiers de données brutes ne sont pas inclus dans ce dépôt afin de garder le repository léger. Le dépôt contient les livrables principaux du projet : requêtes SQL, dictionnaire des données, schéma relationnel, présentation et compte-rendu de réunion.

---

## Modèle relationnel

La base de données a été conçue selon un modèle relationnel normalisé.

Les principales tables sont :

| Table          | Rôle                                                    |
| -------------- | ------------------------------------------------------- |
| `region`       | Stocke les régions françaises                           |
| `departments`  | Stocke les départements et leur région associée         |
| `communes`     | Stocke les communes, leur population et leur code INSEE |
| `properties`   | Stocke les caractéristiques des biens immobiliers       |
| `transactions` | Stocke les transactions immobilières                    |

Les relations principales sont :

* une région peut contenir plusieurs départements ;
* une région peut contenir plusieurs communes ;
* une commune peut contenir plusieurs biens immobiliers ;
* un bien immobilier peut être associé à plusieurs transactions.

Le schéma relationnel est disponible dans le dossier :

```text
diagrams/
```

---

## Dictionnaire des données

Un dictionnaire des données a été réalisé afin de documenter les tables, les colonnes, les types de données, les clés primaires, les clés étrangères et les règles de gestion.

Le dictionnaire couvre notamment :

* la table `region` ;
* la table `departments` ;
* la table `communes` ;
* la table `properties` ;
* la table `transactions`.

Le dictionnaire des données est disponible dans le dossier :

```text
data_dictionary/
```

---

## Nettoyage et transformation des données

Plusieurs opérations de nettoyage et de transformation ont été réalisées :

* suppression des doublons ;
* traitement des valeurs manquantes ;
* création d’une clé `insee_codcom` pour relier les communes aux biens immobiliers ;
* sélection des colonnes utiles ;
* séparation des données en plusieurs tables normalisées ;
* préparation des données pour le chargement dans la base relationnelle ;
* définition des clés primaires et étrangères.

Pour le fichier `Valeurs-foncières.xlsx`, certaines valeurs manquantes ont été traitées selon leur type :

* remplacement de certaines valeurs numériques manquantes par `0` lorsque cela était pertinent ;
* remplacement de certaines valeurs textuelles manquantes par `Unknown` ;
* création des tables `properties` et `transactions` à partir des attributs utiles.

---

## Normalisation

Le modèle relationnel respecte les principes de normalisation :

* **1NF** : les colonnes sont atomiques et ne contiennent pas de groupes répétés ;
* **2NF** : les attributs dépendent de la clé primaire complète ;
* **3NF** : les dépendances transitives sont supprimées afin de réduire la redondance.

Cette normalisation permet d’améliorer la cohérence des données, de limiter les duplications et de faciliter les requêtes SQL.

---

## Besoins d’analyse SQL

Les requêtes SQL répondent aux besoins métier exprimés dans le compte-rendu de réunion, notamment :

1. nombre total d’appartements vendus au premier semestre 2020 ;
2. nombre de ventes d’appartements par région ;
3. proportion des ventes d’appartements par nombre de pièces ;
4. départements où le prix du mètre carré est le plus élevé ;
5. prix moyen du mètre carré d’une maison en Île-de-France ;
6. liste des appartements les plus chers ;
7. évolution du nombre de ventes entre le premier et le deuxième trimestre 2020 ;
8. classement des régions selon le prix au mètre carré ;
9. communes ayant enregistré au moins 50 ventes au premier trimestre ;
10. différence de prix au mètre carré entre les appartements de 2 et 3 pièces.

Les requêtes SQL sont disponibles dans le dossier :

```text
sql/
```

---

## Résultats principaux

Les analyses SQL ont permis d’identifier plusieurs tendances importantes :

* la région **Île-de-France** présente le plus grand nombre de ventes d’appartements ;
* les appartements de **2 pièces** sont les plus vendus, représentant environ **31,18 %** des ventes ;
* les appartements de 1 à 4 pièces représentent plus de 90 % du marché ;
* certains départements comme **Val-d’Oise**, **Essonne** et **Paris** affichent des prix au mètre carré élevés ;
* le prix moyen au mètre carré des maisons en Île-de-France est d’environ **3 997,71 €** ;
* les appartements les plus chers sont concentrés en Île-de-France ;
* une augmentation d’environ **3,68 %** des ventes est observée entre le premier et le deuxième trimestre 2020 ;
* l’Île-de-France affiche le prix moyen au mètre carré le plus élevé, autour de **5 771,30 €** ;
* Paris, Nice, Marseille, Bordeaux et Grenoble figurent parmi les communes importantes en volume de ventes.

---

## Sauvegarde et conformité RGPD

Dans le cadre de ce POC académique, aucune stratégie de sauvegarde complète n’a été mise en œuvre.

Concernant le RGPD, les données utilisées ne contiennent pas de données personnelles directes comme les noms des acquéreurs. L’analyse se concentre sur les transactions immobilières, les biens, les communes, les départements et les régions.

---

## Technologies utilisées

* SQL
* MySQL
* Modélisation relationnelle
* Normalisation
* Dictionnaire des données
* Requêtes SQL analytiques
* Excel
* PowerPoint

---

## Structure du dépôt

```text
.
├── README.md
├── sql/
│   └── projectqueries.sql
├── data_dictionary/
│   └── Abualqumboz_Motasem_dictionaire_112024.xlsx
├── diagrams/
│   └── ER-Diagram project2.png
├── presentation/
│   └── Abualqumboz_Motasem_support_112024.pptx
└── requirements/
    └── CR_réunion.pdf
```

---

## Compétences démontrées

Ce projet démontre les compétences suivantes :

* compréhension d’un besoin métier ;
* lecture et interprétation d’un compte-rendu de réunion ;
* conception d’un dictionnaire des données ;
* modélisation relationnelle ;
* normalisation d’un schéma de base de données ;
* création de tables SQL ;
* définition de clés primaires et étrangères ;
* chargement de données dans une base relationnelle ;
* écriture de requêtes SQL analytiques ;
* interprétation de résultats SQL dans un contexte métier ;
* présentation claire des analyses et recommandations.

---

## Valeur ajoutée du projet

Ce projet montre la capacité à transformer des fichiers de données bruts en une base de données relationnelle structurée et exploitable.

Il démontre également l’importance de la modélisation en amont d’un projet data. Une base bien conçue permet de produire plus facilement des analyses fiables, de répondre à des questions métier et d’aider à la prise de décision.

Dans un contexte professionnel, ce type de travail peut aider une entreprise immobilière à mieux comprendre les tendances du marché, les zones géographiques les plus dynamiques et les caractéristiques des biens les plus recherchés.

---

## Limites et améliorations possibles

Ce projet est un POC académique et présente certaines limites :

* le périmètre se limite au premier semestre 2020 ;
* la stratégie de sauvegarde n’a pas été implémentée ;
* l’analyse pourrait être enrichie avec plusieurs années de données ;
* des tableaux de bord BI pourraient être ajoutés ;
* des procédures d’import automatisées pourraient être développées ;
* une stratégie de sauvegarde et de restauration pourrait être mise en place dans une version plus avancée.

---

## Auteur

**Motasem Abualqumboz**
Parcours Data Engineer — OpenClassrooms
