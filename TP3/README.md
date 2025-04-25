# 🔁 TP Terraform – "Maîtriser les expressions `for`"

## 🎯 Objectif

Comprendre et maîtriser les expressions `for` dans Terraform, dans tous leurs usages :
- Génération de `list`, `map` et `object`
- Filtres conditionnels
- Utilisation avec `for_each` dans des modules ou des ressources
- Transformation de structures complexes

---

## 🧠 Objectifs pédagogiques

À la fin de ce TP, tu sauras :

- Créer des `list` ou `map` dynamiques avec `for`
- Appliquer des filtres avec `if`
- Manipuler et transformer des `map`, `list`, `object` et `tuple`
- Utiliser `for` dans :
  - `locals`
  - `variable` avec valeur par défaut
  - `output`
  - `resource`
  - `module`

---

## 📘 Contexte

Tu veux provisionner une liste de machines virtuelles (VM) avec différents paramètres.  
Les utilisateurs de ton équipe veulent pouvoir déclarer une liste simple et que ton code Terraform s’occupe de générer **les bons noms, tags, configurations**, selon des règles dynamiques via `for`.

---

## 📁 Structure attendue

```
.
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars
```

---

## ✅ Travaux à réaliser

### 🔹 Étape 1 – Déclaration d'une `list(object)` de machines

Déclare une variable `vm_definitions` de type :

```hcl
list(object({
  name     = string
  env      = string
  critical = bool
}))
```

Exemple dans `terraform.tfvars` :

```hcl
vm_definitions = [
  { name = "web1", env = "dev", critical = false },
  { name = "api1", env = "prod", critical = true },
  { name = "batch1", env = "prod", critical = false }
]
```

---

### 🔹 Étape 2 – Génération dynamique d’un nom avec `for` dans un `local`

Dans `locals.tf`, utilise une boucle `for` pour générer une liste de noms de ressources sous le format :

```
<env>-<name>-app
```

---

### 🔹 Étape 3 – Générer dynamiquement des tags

Toujours via `for`, construis une `map` de tags par VM, incluant automatiquement :
- `Name = "<env>-<name>"`
- `Critical = "true"` si la VM est critique

---

### 🔹 Étape 4 – Déploiement avec `null_resource`

Utilise `for_each` sur un `local` construit avec `for` pour générer un `null_resource` par VM, avec :
- Le nom de la VM
- Les tags associés
- Un trigger avec le nom ou la criticité

---

### 🔹 Étape 5 – Output final

Utilise une boucle `for` dans un `output` pour afficher un résumé :

```
- VM dev-web1: non critique
- VM prod-api1: critique
```

---

## 🧪 Bonus

- Applique un `for` imbriqué pour transformer une `map<string, list<string>>` en `list<string>`
- Génère une structure `map<string, map<string, string>>` à partir de `vm_definitions`
- Ajoute un `if` dans une boucle pour ne générer des ressources que pour les `critical == true`

---

## 🧪 Exemple d’utilisation des `for`

```hcl
# Simple
[for vm in var.vm_definitions : vm.name]

# Avec transformation
[for vm in var.vm_definitions : "${vm.env}-${vm.name}-app"]

# Avec condition
[for vm in var.vm_definitions : vm.name if vm.critical]

# Map avec `for`
{ for vm in var.vm_definitions : vm.name => vm.env }

# For imbriqué
flatten([for k, list in local.env_roles : [for role in list : "${k}-${role}"]])
```

---

## 🧪 Test

Lance le plan Terraform avec :

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
```