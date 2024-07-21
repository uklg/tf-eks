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
}

