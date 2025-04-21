# 💡 TP Terraform – Manipulation avancée des variables

## 🎯 Objectif

Apprendre à manipuler tous les types de variables dans Terraform :

- Types simples (`string`, `number`, `bool`)
- Types complexes (`list`, `map`, `object`, `tuple`)
- Typage strict
- Validation de variables
- Fichier `.tfvars` et passage via CLI
- Utilisation de modules avec variables typées

---

## 🧩 Sujet – Provision de users avec rôles et attributs dynamiques

Créer une infrastructure Terraform qui :

1. Déclare des utilisateurs via une variable de type `list(object({...}))`
2. Affecte un rôle à chaque utilisateur
3. Valide que chaque rôle appartient à une liste prédéfinie
4. Utilise un **module** pour gérer la création de chaque utilisateur
5. Passe les variables via :
   - Valeurs par défaut
   - Fichier `.tfvars`
   - Ligne de commande
6. Affiche des `outputs` contenant les informations de chaque utilisateur

---

## 📁 Arborescence

.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    └── user/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

## 🔧 Étapes

### 1. Déclaration de la variable `users`

```hcl
variable "users" {
  description = "Liste des utilisateurs à créer"
  type = list(object({
    username = string
    age      = number
    role     = string
    tags     = map(string)
  }))
  validation {
    condition = alltrue([
      for user in var.users : contains(["admin", "editor", "viewer"], user.role)
    ])
    error_message = "Chaque utilisateur doit avoir un rôle valide : admin, editor ou viewer."
  }
}
```

### 2. Fichier .tfvars 

```hcl
users = [
  {
    username = "alice"
    age      = 29
    role     = "admin"
    tags     = {
      env = "dev"
      team = "backend"
    }
  },
  {
    username = "bob"
    age      = 34
    role     = "viewer"
    tags     = {
      env = "prod"
      team = "infra"
    }
  }
]
```

### 3. Boucle sur les utilisateurs (dans main.tf)

```hcl
module "users" {
  for_each = { for user in var.users : user.username => user }

  source  = "./modules/user"

  username = each.value.username
  age      = each.value.age
  role     = each.value.role
  tags     = each.value.tags
}
```

### 4. Module modules/user/

variables.tf 
```hcl
variable "username" {
  type = string
}
variable "age" {
  type = number
}
variable "role" {
  type = string
}
variable "tags" {
  type = map(string)
}
```

main.tf
```hcl
resource "null_resource" "user" {
  triggers = {
    username = var.username
    role     = var.role
  }
}

output "user_info" {
  value = "User ${var.username}, age ${var.age}, role ${var.role}, tags: ${join(",", [for k, v in var.tags : "${k}=${v}"])}"
}
```

### 5. Passage des variables
via fichier .tfvars
```sh
terraform apply -var-file="terraform.tfvars"
```

via la CLI 
```sh
terraform apply -var='users=[{username="carol", age=27, role="editor", tags={env="stage", team="data"}}]'
```

### 6. Outputs (outputs.tf)
```hcl
output "all_users" {
  value = [for u in module.users : u.user_info]
}
```

### 🧪 Exercice Bonus

✅ Ajouter une validation pour interdire les utilisateurs de moins de 18 ans
✅ Rendre le champ tags optionnel avec une valeur par défaut {} dans le module
✅ Ajouter un champ is_active (type bool) avec true par défaut

### 🚀 Pour aller plus loin

Ajouter une gestion des rôles dans un fichier locals.tf
Générer des ressources conditionnelles selon le rôle (count ou for_each)
Externaliser la config dans plusieurs .tfvars par environnement