# add policy call cert-manager-dns-role
# https://cert-manager.io/docs/configuration/acme/dns01/route53/


# need to install the module and then refer to it to create a dns-role and profile and trust relationship and attach them. A user is creating the R53 records and another user is modifying them dns-manager

resource "aws_iam_policy" "dns-manager" {
  name        = "dns-manager"
  path        = "/"
  description = "Terraform policy to allow cert-manager to create issuers"
#
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
#  policy = file("cert-manager-dns-role.json")
#policy = jsonencode(file("cert-manager-dns-role.yaml"))
 policy = jsonencode(local.config)
 depends_on = [module.eks-cert-manager]

}


locals {
  config = jsondecode(file("cert-manager-dns-role.json"))
  config2 = jsondecode(file("cert-manager-cert-manager.yaml"))

}



resource "aws_iam_role" "dns-manager" {
  name = "dns-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        # copied arn from the module generated cert manager for now. generate self later if needed
        Principal = {
          AWS =  "arn:aws:iam::905418418476:role/cert-manager-irsa-cert-manager"
        }
      },
    ]
  })
  #depends_on = [module.eks-cert-manager]
  depends_on = [aws_iam_policy.dns-manager]

}

# lots of docs here for this
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
# The name of the IAM role to which the policy should be applied

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "dns-manager"
  policy_arn = "arn:aws:iam::905418418476:policy/dns-manager"
  depends_on = [aws_iam_role.dns-manager]

}


# will skip cross account access for now

/*
  
resource "aws_iam_policy" "cert-manager" {
  name = "cert-manager"
  path        = "/"
  description = "Terraform policy to allow cert-manager to create issuers"
#
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
#  policy = file("cert-manager-dns-role.json")
#policy = jsonencode(file("cert-manager-dns-role.yaml"))
 policy = jsonencode(local.config2)
}


*/


#cert-manager-cert-manager.yaml




# "Principal": {
#         "AWS": "XXXXXXXXXXX"
#       }


