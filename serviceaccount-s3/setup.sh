#!/bin/bash

# echo turn off ebs-csi as this is not prod and we do not need permanent pvs mounted here
kubectl delete deployments.apps -n kube-system ebs-csi-controller


kubectl delete -f deployment.yaml

kubectl apply -f deployment.yaml


sleep 1
kubectl get pod
