module "users" {
  for_each = { for user in var.users : user.username => user }
  source   = "./modules/user"

  username = each.value.username
  age      = each.value.age
  role     = each.value.role
  tags     = each.value.tags
}