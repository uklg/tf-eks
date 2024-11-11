#!/bin/bash




cd ../


export cluster_name=$(terraform output cluster_name| tr -d '"')


cd -


echo check to see if ebi-csi driver is installed in the eks cluster. check for ACTIVE status


aws eks describe-addon --cluster-name education-eks-OQCBxcyH --addon-name aws-ebs-csi-driver



echo check its components are running
kubectl get deploy,ds -l=app.kubernetes.io/name=aws-ebs-csi-driver -n kube-system

echo and here

kubectl get po -n kube-system -l 'app in (ebs-csi-controller,ebs-csi-node)'


## match to name
#kubectl get -n kube-system pod/ebs-csi-controller-67c885fcc7-n6ll6 -o jsonpath='{.spec.containers[*].ebs-csi-node-7qjjv}'


echo By default, every node is capable of using CSI-based Amazon EBS volumes

kubectl get csinodes


echo
echo Every Amazon EKS cluster currently comes with an in-tree plugin–based StorageClass - sc

kubectl get sc


# NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
# gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false       

echo 'To use the external EBS CSI driver, we need to create a new StorageClass based upon it:'


echo apply the storage class


kubectl apply -f gp3-sc.yaml



echo see the specific class
kubectl get sc gp3

echo see all the classes 

kubectl get sc

#NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
# gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  167m
# gp3             ebs.csi.aws.com         Delete          WaitForFirstConsumer   true                   2m24s



echo We can see the provisioner is ebs.csi.aws.com



echo 'Note: Because the GA version supports the volume resizing feature, we set the allowVolumeExpansion property to true'
