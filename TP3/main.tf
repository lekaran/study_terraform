resource "terraform_data" "vm" {
  for_each = {
    for vm in local.vm_tags : vm.Name => vm
  }

  input = {
    tags = {
      Name     = each.value.Name
      Critical = each.value.Critical
    }
  }
  
  triggers_replace = {
    Name = each.value.Name
  }
}