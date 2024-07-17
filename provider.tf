# update config to point to the new config if it exists at

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
  depends_on = [module.eks]

}

# contents of ~/.kube/config  (updated when asws kubectl config commmand is run for example:

# ...
# arn:aws:eks:eu-north-1:905418418476:cluster/education-eks-6QbWFVXD
# ...

module "eks-kubeconfig" {
  source  = "hyperbadger/eks-kubeconfig/aws"
  version = "2.0.0"
  cluster_name = module.eks.cluster_name
  depends_on = [module.eks]

