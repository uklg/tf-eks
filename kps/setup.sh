#!/bin/bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create ns monitoring







#https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml


echo Install the stack with the custom values.yaml file. THis can be updated or referenced if changed


wget -O  custom.yaml https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml



helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f custom-moved.json -n monitoring


echo dispay the pod status 

kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"



