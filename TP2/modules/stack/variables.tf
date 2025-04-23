variable "instance_count" {
  description = "Le nombre d'instance que l'on doit créer"
  type        = number
}

variable "instance_type" {
  description = "Le type d'instance à utiliser pour créer les instances de VM"
  type        = string
}

variable "region" {
  description = "La région ou l'on va créer les instances"
  type        = string
}

variable "enable_monitoring" {
  description = "Est ce que le monitoring est activé"
  type        = bool
}

variable "tags" {
  description = "Les tags pour les intances"
  type        = map(string)
}