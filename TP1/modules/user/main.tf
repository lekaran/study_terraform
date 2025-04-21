resource "terraform_data" "user" {
  triggers_replace = {
    username = var.username
    role = var.role
  }
}