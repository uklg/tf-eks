eks automode sorts a lot of things out worth turning on and can turn on on existing cluster or patch this one with a eksctl  command or similar


https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html


 EKS Auto


CoreDNS
Amazon EFS CSI driver
Mountpoint for Amazon S3 CSI Driver
AWS Distro for OpenTelemetry
Amazon GuardDuty agent
Amazon CloudWatch Observability agent
 

 EKS


---

way to add the oidc

 https://github.com/terraform-aws-modules/terraform-aws-iam

 module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "role-with-oidc"

  tags = {
    Role = "role-with-oidc"
  }

  provider_url = "oidc.eks.eu-west-1.amazonaws.com/id/BA9E170D464AF7B92084EF72A69B9DC8"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
  number_of_role_policy_arns = 1
}
