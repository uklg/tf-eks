#!/bin/bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create ns monitoring







#https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml


echo Install the stack with the custom values.yaml file


wget -O  custom.yaml https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml

exit

helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f ~/Documents/kube-prometheus-stack-values.yaml -n monitoring



