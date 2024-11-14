

resource "helm_release" "secrets_csi_driver" {
  name = "secrets-store-csi-driver"

  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.4.3"

  # MUST be set if you use ENV variables
  set {
    name  = "syncSecret.enabled"
    value = true
  }

  #depends_on = [helm_release.efs_csi_driver]
}


resource "helm_release" "secrets_csi_driver_aws_provider" {
  name = "secrets-store-csi-driver-provider-aws"

  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"
  version    = "0.3.8"

  depends_on = [helm_release.secrets_csi_driver]
}

#output


output "a" {
  value = local.sgId
}


output "blah" {
  value = local.sgId.cluster_name
}







/*
resource "aws_iam_role" "myapp_secrets" {
  name               = "${local.sgId.cluster_name}-myapp-secrets"
  #assume_role_policy = aws_iam_policy_document.myapp_secrets.policy
  assume_role_policy = aws_iam_policy.myapp_secrets.policy
  #depends_on = [aws_iam_policy.myapp_secrets]
}
*/





resource "aws_iam_policy" "myapp_secrets" {
  name = "${local.sgId.cluster_name}-myapp-secrets"



   policy           = jsonencode(
       {
           Statement = [
               {
                   Action   = [
                       "secretsmanager:GetSecretValue",
                       "secretsmanager:DescribeSecret",
                    ]
                   Effect   = "Allow"
                   Resource = "*"
               },
           ]
           Version   = "2012-10-17"
       }
   )


}



output "blah2" {


  #value = "a"
  value = "eksctl create iamserviceaccount --name nginx-deployment-sa --region ${local.sgId.region}"

  #  value = "eksctl create iamserviceaccount --name nginx-deployment-sa --region "${local.sgId.region}" --cluster "${local.sgId.cluster_name}" --attach-policy-arn "${aws_iam_policy.myapp_secrets.arn}" --approve --override-existing-serviceaccounts"#

}



resource "null_resource" "update_iam_policy" {

  #

  triggers = {
    # always run this instead of just once
    #always_run = timestamp()

  }

  provisioner "local-exec" {

    #command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
    command = "eksctl create iamserviceaccount --name nginx-deployment-sa --region ${local.sgId.region} --cluster ${local.sgId.cluster_name} --attach-policy-arn ${aws_iam_policy.myapp_secrets.arn} --approve --override-existing-serviceaccounts"


    #command = module.eks.cluster_name

  }
#  depends_on = [module.null_resource.udpdate_ec2]
  depends_on = [aws_iam_policy.myapp_secrets]


}







/*
resource "aws_iam_role_policy_attachment" "myapp_secrets" {
  policy_arn = aws_iam_policy.myapp_secrets.arn
  role       = aws_iam_role.myapp_secrets.name
}

/*

output "myapp_secrets_role_arn" {
  value = aws_iam_role.myapp_secrets.arn
}


 */



output "policy_arn" {
  value = aws_iam_policy.myapp_secrets.arn
}
