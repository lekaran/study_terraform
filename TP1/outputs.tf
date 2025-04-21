output "all_users" {
  value = [for u in module.users : u.user_infos]
}