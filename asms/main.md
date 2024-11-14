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




---

rotating secrets

after deploy secret change may need redeployment after secret change to pick it up. can redeploy same code potentially. or it might to itself check after one hour still same after several hours so need to redeploy or similar to pick up new secret. This probably makese a lot of sense as otherwise app logic needs to be able to deal with all these changes.  Here new process new secret.

keep old password and new password in database for a bit


having two secrets makes the pod not too spin up need to fix
now any secrets works ok

---


Additional Considerations from https://github.com/aws/secrets-store-csi-driver-provider-aws

Rotation

When using the optional alpha rotation reconciler feature of the Secrets Store CSI driver the driver will periodically remount the secrets in the SecretProviderClass. This will cause additional API calls which results in additional charges. Applications should use a reasonable poll interval that works with their rotation strategy. A one hour poll interval is recommended as a default to reduce excessive API costs.

Anyone wishing to test out the rotation reconciler feature can enable it using helm:

helm upgrade -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set enableSecretRotation=true --set rotationPollInterval=3600s

Automated Failover Regions

In order to provide availability during connectivity outages or for disaster recovery configurations, this provider supports an automated failover feature to fetch secrets or parameters from a secondary region. To define an automated failover region, define the failoverRegion in the SecretProviderClass.yaml file:

spec:
  provider: aws
  parameters:
    region: us-east-1
    failoverRegion: us-east-2



Security Considerations
The AWS Secrets Manager and Config Provider provides compatibility for legacy applications that access secrets as mounted files in the pod. Security conscious applications should use the native AWS APIs to fetch secrets and optionally cache them in memory rather than storing them in the file system.


Click on a secret and python code is here to access this secret now the secret is not stored in plaintext anywhere




The create iamaccount effects the eks cluster
List service account account


```
$ kubectl get serviceaccount nginx-deployment-sa -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::905418418476:role/eksctl-education-eks-3EYgYeqg-addon-iamservic-Role1-EjBw1juX5oAr
  creationTimestamp: "2024-11-14T10:40:32Z"
  labels:
    app.kubernetes.io/managed-by: eksctl
  name: nginx-deployment-sa
  namespace: default
  resourceVersion: "10199"
  uid: d41a50a0-b23c-44b6-b61c-bd5cc35a74ba
```




=== instances not spinning up

 kubectl describe  deployment nginx-deployment

shows
FailedCreate


kubectl describe rs


Type     Reason        Age                   From                   Message
  ----     ------        ----                  ----                   -------
  Warning  FailedCreate  81s (x17 over 6m49s)  replicaset-controller  Error creating: pods "nginx-deployment-5867db46ff-" is forbidden: error looking up service account default/nginx-deployment-sa: serviceaccount "nginx-deployment-sa" not found



or kubectl describe events 

and look through events


