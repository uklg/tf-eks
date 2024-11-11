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

echo  'No migration of in-tree to external CSI provisioner occurs when using the Amazon EKS managed add-on Amazon EBS CSI.'


echo 'Now we create a PersistentVolumeClaim (PVC), which will be used by a pod to show the dynamic provisioning capability of a gp3-based StorageClass'

kubectl apply -f pvc-csi.yaml

kubectl get pvc


# NAME      STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# pvc-csi   Pending



echo 'The PVC is still in pending status because the gp3 StorageClass uses a volumeBindingMode of WaitForFirstConsumer. This attribute makes sure that the PersistentVolume (PV) and Pod will be provisioned in the same AWS availability zone (AZ)'




echo create the pod with a pv def
kubectl apply -f pod-csi.yaml


echo waiting for pod to spin up
sleep 2
echo  
kubectl get pod


kubectl get pvc

echo should be able to see bound here


deletiing


when deleting the infra do not delete the pvs if they are to be used by otehr pods


kubectl delete pvc pvc-csi


the module will delete the pvc and this

$ kubectl delete pod app-gp3
$ kubectl delete pvc pvc-csi

$ kubectl get pv

will be blank



when deleting the infra do not delete the pvs if they are to be used by otehr pods



one way to do this to remove the state for this pvc if the environment type is prod and thus it will be set free and will not be deleted

if the env type is test then do not remove the state and then the pvc and thus pv is tidied up after deletion



add env variable to the output

if variable is prod then do something like remove the state for the created pv in create script



Today we are happy to share the general availability of the Amazon EBS CSI EKS add-on. This release contains added functionality, such as volume resizing and snapshotting for Linux, Windows support including snapshotting but without resizing


todo: add snapshotting


add output part to the wiki terraform and the script capture of output


Your PersistenVolumes will not be terminated while there is a pod, deployment or to be more specific - a PersistentVolumeClaim using it.



change reclaim policy form delete


ubectl get sc
NAME            PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
gp2 (default)   kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  6h19m
gp3             ebs.csi.aws.com         Delete          WaitForFirstConsumer   true                   3h34m
rm@mini:~/i4/terraform$



then it will be kept

Delete/
Retain





The PV is not available for another claim after the PV has been released of its previous claim because the previous claimant's data is still on the volume. Recover the data and then re-create the PV using the same storage to make a new claim on that storage.

create a new pvc with same name and it will be attached to the correct pod


Delete the PV.

kubectl delete pv pv_name

The associated block volume or file system still exists after the PV is deleted.

Manually recover and clean up the data on the block volume or file system.

(Optional) Manually delete the block volume or file system.

To reuse the same block volume or file system, create a new PV with the same storage asset definition.



