output "vms_summary" {
  value = {
    for vm_key, vm_resource in terraform_data.vm :
    vm_key => {
      name     = vm_resource.input.tags.Name
      critical = vm_resource.input.tags.Critical
    }
  }
}
