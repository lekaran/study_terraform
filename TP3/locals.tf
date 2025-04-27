locals {
  vm_name = [for vm in var.vm_definitions : "${vm.env}-${vm.name}-app"]
  vm_tags = [for vm in var.vm_definitions : {
    Name     = "${vm.env}-${vm.name}"
    Critical = vm.critical ? "true" : "false"
    }
  ]
}