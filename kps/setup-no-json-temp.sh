#!/bin/bash
$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create ns monitoring







#https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml


echo Install the stack with the custom values.yaml file. THis can be updated or referenced if changed


wget -O  custom.yaml https://raw.githubusercontent.com/prprasad2020/don-cortex-demo/refs/heads/main/Kube-Prometheus-Stack/kube-prometheus-stack-values.yaml



#helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -f custom-moved.json -n monitoring


helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring





echo dispay the pod status 

kubectl --namespace monitoring get pods -l "release=kube-prometheus-stack"



kubectl get pod -A


echo wait for pod
sleep 1




kubectl -n monitoring port-forward pod/$(kubectl get pod -n monitoring|grep grafana|cut -d ' ' -f 1) 3000:3000 &




echo port forward set up point browser to http://localhost:3000 for grafana

exit 0


echo here the secret is created

kubectl describe secret kube-prometheus-stack-grafana -n monitoring

Type:  Opaque

Data
====
admin-password:  13 bytes
admin-user:      5 bytes
ldap-toml:       0 bytes



need to get this password


and proxy it

---

kubectl get secrets kube-prometheus-stack-grafana -n monitoring -o json

    "data": {
        "admin-password": "cHJvbS1vcGVyYXRvcg==",
        "admin-user": "YWRtaW4=",
        "ldap-toml": ""


need to convert this from base64

kubectl get secrets kube-prometheus-stack-grafana -n monitoring -o jsonpath='{.data.admin-password}'|base64 -d



kubectl get secrets kube-prometheus-stack-grafana -n monitoring -o jsonpath='{.data.admin-user}'|base64 -d


---
kubectl describe pod kube-prometheus-stack-grafana-84c768fd8f-dfxz9 -n monitoring |grep Ports
    Ports:           3000/TCP, 9094/TCP, 9094/UDP




kubectl -n monitoring port-forward pod/kube-prometheus-stack-grafana-84c768fd8f-dfxz9 3000:3000


browser

localhost:3000



can login with the creds displayed



this seems to be working as expected


