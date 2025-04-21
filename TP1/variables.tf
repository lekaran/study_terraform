variable "users" {
  description = "List of the users to create"
  type = list(object({
    username = string
    age      = number
    role     = string
    tags     = map(string)
  }))
  validation {
    condition = alltrue([
      for user in var.users : contains(["admin", "editor", "viewer"], user.role)
    ])
    error_message = "Each user must have a valid role like : admin, editor or viewer."
  }
}

