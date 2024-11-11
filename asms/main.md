Access ASMS from EKS


https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html

https://docs.aws.amazon.com/secretsmanager/latest/userguide/integrating_csi_driver.html

Step 1: Set up access control


1
    Create a permissions policy that grants secretsmanager:GetSecretValue and secretsmanager:DescribeSecret permission to the secrets that the pod needs to access. For an example policy, see Example: Permission to read and describe individual secrets.



