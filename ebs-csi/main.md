setup ebs csi persisent volume storage


Keep in mind that the underlying EBS volume of a PV is bound to an AZ. If you want to stop and restart the pod later on, make sure to add nodeSelector or nodeAffinity to the YAML specification to run the pod on a node that is part of the same AZ as the EBS volume.


https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/

code that would be needed but not needed here

```
$ cat eks-add-on-ebs-csi.tf
...
data "aws_eks_cluster" "eks" {
  name = local.name
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${local.name}"
  provider_url                  = replace(data.aws_eks_cluster.eks.identity.0.oidc.0.issuer, "https://", "")
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:eb
```





To use the external EBS CSI driver, we need to create a new StorageClass based upon it:

cat gp3-sc.yaml
```
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: gp3
allowVolumeExpansion: true
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
parameters:
  type: gp3
```

apply this

Now we create a PersistentVolumeClaim (PVC), which will be used by a pod to show the dynamic provisioning capability of a gp3-based StorageClass:

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-csi
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: gp3
  resources:
    requests:
      storage: 1Gi

```


apply this



kubectl get pvc

 The PVC is still in pending status because the gp3 StorageClass uses a volumeBindingMode of WaitForFirstConsumer. This attribute makes sure that the PersistentVolume (PV) and Pod will be provisioned in the same AWS availability zone (AZ)

