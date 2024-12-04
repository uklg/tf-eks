provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  # loot at eks outputs and match the script here
  # https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aeks
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest?tab=outputs
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_endpoint
    ]
  }
  # build eks before tring to build auth config for it
  # may make sure referenced eks variables are accessible before running it
  #depends_on = [module.eks]
}

