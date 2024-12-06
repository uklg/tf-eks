#!/bin/bash

# echo turn off ebs-csi as this is not prod and we do not need permanent pvs mounted here
kubectl delete deployments.apps -n kube-system ebs-csi-controller


kubectl delete -f deployment.yaml

kubectl apply -f deployment.yaml


sleep 2
kubectl get pod



echo login in to pod

echo yum install awscli
aws ls


echo 'An error occurred (AccessDenied) when calling the AssumeRoleWithWebIdentity operation: Not authorized to perform sts:AssumeRoleWithWebIdentity'


echo need to add this in to iam rules

echo kubectl exec -it pod/app-name-7c6c5f46d6-bz257 -- /bin/bash





kubectl delete -f infinte-run-deployment.yaml

kubectl apply -f infinte-run-deployment.yaml

pod_name=$(kubectl get pod|grep app-name-infinite|cut -d ' ' -f 1)


echo kubectl wait --for=jsonpath='{status.availableReplicas}' deployments/app-name-infinite --timeout=10s


echo pod_name=$(kubectl get pod|grep app-name-infinite|cut -d ' ' -f 1)


pod_name=$(kubectl get pod|grep app-name-infinite|cut -d ' ' -f 1)


echo use this to connect to infinity pod
echo  kubectl exec -it pod/$pod_name -- /bin/bash

