variable "environments" {
  description = "Le nom de l'environnement"
  type = map(object({
    instance_count    = number
    instance_type     = string
    region            = string
    enable_monitoring = bool
    tags              = map(string)
  }))
  validation {
    # tester si l'instances type est dans une liste autorisée
    # ET
    # tester si la region est dans une liste blanche de region
    condition = alltrue([
      for env in var.environments : contains(["eu-central-1", "eu-west-1", "eu-west-2", "eu-west-3", "eu-north-1"], env.region) && contains(["t3.small", "t3.medium"], env.instance_type)
    ])
    error_message = "Soit la région n'est dans la liste blanche soit c'est le type d'instance qui n'est pas dans la liste blanche"
  }
}

/*

contains(["eu-central-1","eu-west-1","eu-west-2","eu-west-3","eu-north-1"], var.environments.region) && contains(["t3.small","t3.medium"], var.environments.instance_type)

{
  "dev" = {
    instance_count = 1
    instance_type = "t3.small"
    region = "eu-west-3"
    enable_monitoring = false
    tags = {
      "env" = "dev"
      "team" = "backend"
    }
  }
  "ver" = {
    instance_count = 2
    instance_type = "t3.small"
    region = "eu-west-3"
    enable_monitoring = false
    tags = {
      "env" = "ver"
      "team" = "backend"
    }
  }
  "homol" = {
    instance_count = 3
    instance_type = "t3.medium"
    region = "eu-west-3"
    enable_monitoring = true
    tags = {
      "env" = "homol"
      "team" = "backend"
    }
  }
  "prod" = {
    instance_count = 4
    instance_type = "t3.medium"
    region = "eu-west-3"
    enable_monitoring = true
    tags = {
      "env" = "prod"
      "team" = "backend"
    }
  }
}
*/