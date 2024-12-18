data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name

}

data "tls_certificate" "default" {
  url = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
}

#resource "aws_iam_openid_connect_provider" "default" {
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
#  url             = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
#}


locals {
  url = data.aws_eks_cluster.default.identity[0].oidc[0].issuer
  policy = replace (module.eks.cluster_oidc_issuer_url, "https://", "")
}




resource "aws_iam_role" "default" {
  name = "eks-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = ""
      Effect = "Allow",
      Principal = {
        #Federated = aws_iam_openid_connect_provider.default.arn
        Federated = module.eks.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          # "${aws_iam_openid_connect_provider.default.url}:sub" = "system:serviceaccount:default:my-service-account"
            "${local.policy}:sub" = "system:serviceaccount:default:my-service-account"
          # "${aws_iam_openid_connect_provider.default.url}:aud" = "sts.amazonaws.com"  
            "${local.policy}:aud" = "sts.amazonaws.com"
          }
      }
    }]
  })
}


resource "aws_iam_role_policy" "default" {
  name   = "eks-irsa-policy"
  role   = aws_iam_role.default.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:ListAllMyBuckets"
      ],
      Resource = "*"
    }]
  })
}





resource "kubernetes_service_account" "example" {
  metadata {
    name      = "my-service-account"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.default.arn
    }
  }
}



