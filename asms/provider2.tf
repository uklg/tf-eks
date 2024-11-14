/*
terraform {
  required_version = ">= 1.9.1"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.29.3"
    }
  }
}


*/


terraform {
  required_version = ">= 1.9.1"

  required_providers {
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 1.29.3"
    }
  }
}
