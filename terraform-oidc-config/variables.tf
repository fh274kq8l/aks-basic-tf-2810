variable "prefix" {
  type    = string
  default = "<prefix>"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "github_organisation_target" {
  type    = string
  default = "fh274kq8l"
}

variable "github_organisation_template" {
  type    = string
  default = "fh274kq8l"
}

variable "github_repository_template" {
  type    = string
  default = "basic-aks-tf-bootstrap"
}

variable "environments" {
  type    = list(string)
  # default = ["dev", "test", "prod"]
  default = ["dev"]
}

variable "use_managed_identity" {
  type    = bool
  default = true
  description = "If selected, this option will create and configure a user assigned managed identity in the subscription instead of an AzureAD service principal."
}