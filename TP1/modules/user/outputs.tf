output "user_infos" {
  value = "User ${var.username}, age ${var.age}, role ${var.role}, tags: ${join(",",[for k, v in var.tags : "${k}=${v}"])}"
}