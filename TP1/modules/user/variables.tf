variable "username" {
  description = "This is the username of the user"
  type = string
}

variable "age" {
  description = "This is the user's age"
  type = number
}

variable "role" {
  description = "This is the user's role in the organization"
  type = string
}

variable "tags" {
  description = "This is tags that we will use on all our resources"
  type = map(string)
}