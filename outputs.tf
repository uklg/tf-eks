# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}


output "cluster_identity_oidc_issuer" {
  value   = module.eks.cluster_oidc_issuer_url # issuer is provider without the https://
}

output "cluster_identity_oidc_issuer_arn" {
  value =  module.eks.oidc_provider_arn 
}
