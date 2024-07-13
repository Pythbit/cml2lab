variable "nb_address" {
  type        = string
  description = "Netbox Instance URL"
}

variable "nb_token" {
  type        = string
  description = "Netbox API Token"
}

variable "cml_address" {
  type        = string
  description = "CML Instance URL"
}

variable "cml_user" {
  type        = string
  description = "CML API Token"
}

variable "cml_pass" {
  type        = string
  sensitive   = true
  description = "CML API Token"
}

