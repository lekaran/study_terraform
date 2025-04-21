# 📦 TP Terraform – "Déploiement multi-environnements d’une stack applicative"

## 🎯 Objectif

Tu vas concevoir une structure Terraform générique et modulaire pour **déployer une application dans plusieurs environnements** (`dev`, `staging`, `prod`).  
Tu devras manipuler des **types de variables complexes**, **typage strict**, **validation**, **passage via fichiers ou CLI**, **différences d’environnements**, et **modularité**.

---

## 🧠 Objectifs pédagogiques

- Utiliser des `map`, `object`, `list(object)`, `tuple` pour définir la configuration de chaque environnement
- Appliquer une stratégie DRY (Don't Repeat Yourself) avec `locals` et modules
- Passer des variables complexes à un module
- Comprendre la distinction entre "configuration globale" et "configuration spécifique à un environnement"
- Valider les entrées utilisateurs (`validation` sur types complexes)

---

## 📝 Contexte

Tu veux déployer une **stack applicative** générique (par exemple : un serveur web avec du monitoring) sur plusieurs environnements. Chaque environnement (`dev`, `staging`, `prod`) peut avoir des paramètres différents :

| Paramètre             | Type                     | Exemple                       |
|-----------------------|--------------------------|-------------------------------|
| `instance_count`      | number                   | 1 en dev, 2 en prod           |
| `instance_type`       | string                   | "t3.micro", "t3.medium"       |
| `tags`                | map(string)              | `env = dev`, `team = backend` |
| `enable_monitoring`   | bool                     | `true` ou `false`             |
| `region`              | string                   | "eu-west-1", etc.             |

Tu dois **modéliser tout cela dans une seule variable `environments` de type `map(object({...}))`**, avec validations.

---

## ✅ Travaux à réaliser

1. **Créer la variable `environments`** dans `variables.tf` :
   - Clé = nom de l’environnement (`dev`, `prod`, etc.)
   - Valeur = `object` contenant tous les paramètres ci-dessus
   - Ajoute des règles de validation (ex : instance type dans une liste autorisée)

2. **Créer un module `stack/`** :
   - Qui reçoit tous les paramètres de l’environnement
   - Qui simule un déploiement via des `null_resource` (ou plus si tu veux vraiment déployer sur AWS)

3. Dans `main.tf`, **utilise `for_each` sur `var.environments`** pour instancier un module par environnement.

4. **Créer un fichier `terraform.tfvars`** pour initialiser les environnements `dev` et `prod`.

5. **Ajouter des `outputs`** par environnement et un output global avec les résultats des stacks.

---

## 🧪 Bonus (optionnel mais recommandé)

- Ajoute une structure `object` imbriquée pour gérer les paramètres de monitoring :
  ```hcl
  monitoring = object({
    enabled    = bool
    frequency  = number
  })
  ```
- Crée une validation qui interdit `prod` avec `instance_type = "t3.micro"`
- Génère dynamiquement des tags par environnement via `locals`

---

## 🧪 Exemple d’entrée attendue (dans `terraform.tfvars`) :

```hcl
environments = {
  dev = {
    instance_count    = 1
    instance_type     = "t3.micro"
    tags              = { env = "dev", team = "backend" }
    enable_monitoring = true
    region            = "eu-west-1"
  }
  prod = {
    instance_count    = 2
    instance_type     = "t3.medium"
    tags              = { env = "prod", team = "backend" }
    enable_monitoring = true
    region            = "eu-west-1"
  }
}
```

---

## 📌 Objectifs de validation finale

- Ton code est 100% modulaire
- Les valeurs sont typées strictement
- Les erreurs de configuration sont bloquées par Terraform (`terraform validate`)
- Tu peux lancer des tests via :
  - fichier `.tfvars`
  - valeurs par défaut
  - CLI