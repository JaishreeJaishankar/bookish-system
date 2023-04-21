variable "namespace" {
  type        = string
  description = "Project name"
  default     = "library-management-system"
}

variable "name" {
  type        = string
  description = "What is this web app???"
  default     = "bookish-ninja"
}

variable "environments" {
  description = "Environments"
  type        = list(string)
  default     = ["dev", "prod"]
}
