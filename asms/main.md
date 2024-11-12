Access ASMS from EKS


you use a private Amazon EKS cluster, ensure that the VPC that the cluster is in has a Secrets Manager endpoint. The Secrets Store CSI Driver uses the endpoint to make calls to Secrets Manager. For information about creating an endpoint in a VPC, see VPC endpoint.



this is a private cluster


todo: check the vpc module for this








https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html

https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html

Step 1: Set up access control


1
    Create a permissions policy that grants secretsmanager:GetSecretValue and secretsmanager:DescribeSecret permission to the secrets that the pod needs to access. For an example policy, see Example: Permission to read and describe individual secrets.


terraform-aws-modules/eks/aws



---

may be able to add this



      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn






terraform-aws-modules/vpc/aws


---


If you use a private Amazon EKS cluster, ensure that the VPC that the cluster is in has a Secrets Manager endpoint. The Secrets Store CSI Driver uses the endpoint to make calls to Secrets Manager. F





com.amazonaws.region.secretsmanager



(https://docs.aws.amazon.com/secretsmanager/latest/userguide/vpc-endpoint-overview.html)



se helm wherever posible to do useful things quickly

https://www.youtube.com/watch?v=ppJZ4m4t0bI

watch wwhole course prefereably


---


got the helm readme working

very informative

https://github.com/aws/secrets-store-csi-driver-provider-aws


