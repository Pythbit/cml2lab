terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "~> 3.8.7"
    }
    cml2 = {
      source  = "CiscoDevNet/cml2"
      version = "~> 0.7.0"
    }
    http = {}
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}
