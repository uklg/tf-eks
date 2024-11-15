#!/bin/bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

#kubectl create ns monitoring
kubectl create namespace prometheus



helm install stable prometheus-community/kube-prometheus-stack -n prometheus





#https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml


echo Install the stack with the custom values.yaml file








