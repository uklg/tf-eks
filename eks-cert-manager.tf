# https://registry.terraform.io/modules/lablabs/eks-cert-manager/aws/latest?tab=inputs

module "eks-cert-manager" {
  source  = "lablabs/eks-cert-manager/aws"
  version = "1.2.0"
  # insert the 2 required variables here

# required inputs
cluster_identity_oidc_issuer=module.eks.cluster_oidc_issuer_url # issuer is provider without the https://
cluster_identity_oidc_issuer_arn =  module.eks.oidc_provider_arn # if `enable_irsa = true` which is default when generating a cluster provides this output which is needed and so is oidc

  depends_on = [module.eks-load-balancer-controller]
}

# terarorm  errors
# need to add STS: GetCallerIdentity,

#				"sts:GetCallerIdentity"
# add save and wait to iam role
