#!/bin/bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create ns monitoring







#https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml


echo Install the stack with the custom values.yaml file. THis can be updated or referenced if changed


wget -O  custom.yaml https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml



#helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f custom-moved.json -n monitoring


echo fix the failed metrics eks does not need so can ignore
helm install -f values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring





echo dispay the pod status 

kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"



kubectl get pod -A


echo wait for pod
sleep 1




kubectl -n monitoring port-forward pod/$(kubectl get pod -n monitoring|grep grafana|cut -d ' ' -f 1) 3000:3000 &




echo port forward set up point browser to http://localhost:3000 for grafana

exit 0
