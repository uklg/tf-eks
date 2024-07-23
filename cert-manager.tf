# add policy call cert-manager-dns-role
# https://cert-manager.io/docs/configuration/acme/dns01/route53/


resource "aws_iam_policy" "policy2" {
  name        = "dns-manager"
  path        = "/"
  description = "Terraform policy to allow cert-manager to create issuers"
#
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
#  policy = file("cert-manager-dns-role.json")
#policy = jsonencode(file("cert-manager-dns-role.yaml"))
 policy = jsonencode(local.config)
}


locals {
  config = jsondecode(file("cert-manager-dns-role.json"))
  config2 = jsondecode(file("cert-manager-cert-manager.yaml"))

}



resource "aws_iam_role" "dns-manager" {
  name = "test_role"

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


