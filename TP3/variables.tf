variable "vm_definitions" {
  description = "The list of the VMs definition"
  type = list(object({
    name     = string
    env      = string
    critical = bool
  }))
}