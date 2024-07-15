# https://registry.terraform.io/modules/lablabs/eks-load-balancer-controller/aws/latest?tab=inputs

module "eks-load-balancer-controller" {
  source  = "lablabs/eks-load-balancer-controller/aws"
  version = "1.3.0"
  # insert the 3 required variables here

  # these may work without this
  cluster_identity_oidc_issuer=module.eks.cluster_oidc_issuer_url # issuer is provider without the https://

  cluster_identity_oidc_issuer_arn =  module.eks.oidc_provider_arn # if `enable_irsa = true`
  cluster_name = module.eks.cluster_name
}


# this was needed to stop error: https://stackoverflow.com/questions/66427129/terraform-error-kubernetes-cluster-unreachable-invalid-configuration
# export KUBE_CONFIG_PATH=~/.kube/config
# terraform apply

# kubectl get deployments.apps  -A
# NAMESPACE           NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
# aws-lb-controller   aws-load-balancer-controller   2/2     2            2           3m13s


# kubectl get events -A
# aws-lb-controller   4m33s       Normal    ScalingReplicaSet        deployment/aws-load-balancer-controller              Scaled up replica set aws-load-balancer-controller-8548dd7477 to 2


# this controller  mutates the requestes to load balancer to point to the single alb 
