#!/bin/bash




cd ../


export cluster_name=$(terraform output cluster_name| tr -d '"')




echo check to see if ebi-csi driver is installed in the eks cluster. check for ACTIVE status


aws eks describe-addon --cluster-name education-eks-OQCBxcyH --addon-name aws-ebs-csi-driver



echo check its components are running
kubectl get deploy,ds -l=app.kubernetes.io/name=aws-ebs-csi-driver -n kube-system

echo and here

kubectl get po -n kube-system -l 'app in (ebs-csi-controller,ebs-csi-node)'
