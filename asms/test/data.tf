data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../../terraform.tfstate"
  }
}


locals {
  sgId = data.terraform_remote_state.eks.outputs
}

