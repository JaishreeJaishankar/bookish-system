variable "domain_name" {
  type        = string
  description = "DNS name you own"
  default     = "explore-cloud-stuff.online"
}

variable "stage" {
  type        = string
  description = "Deployment stage, e.g. dev, test, prod"
  default     = "dev"
}

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