adding kps a monitoring stack to eks cluster

(in future add in managed service and then it can complain about a missing cluster) but do could aws monitoring basic do that)



https://github.com/prometheus-operator/kube-prometheus



This will create a stack and sample monitoring refer to minikube/kube-promethiuus-stack




https://medium.com/@priyankar9805/deploy-kube-prometheus-stack-on-eks-cluster-f1352101bf69

hopefully custom yaml can setup notifications






run ./setup.sh

it works so far apart from grafana  stack pods

had to clean up test helm




kubectl get pod -A




kubectl describe -n monitoring pod/kube-prometheus-stack-grafana-0


lots of stuff to look at here very useful




trying to spin up a pv investigate


---


Since the alertmanager configuration can have SMTP server credentials or any other tokens as plain text in the configuration, AlertmanagerConfig CRD can be used to create those configuration separately and it can be adding to alertmanager when deploying the kube-prometheus-stack.


grep file

here a file contents is converted into a value this is cool:

custom.yaml:      user: $__file{/etc/secrets/grafana/smtp_user}
custom.yaml:      password: $__file{/etc/secrets/grafana/smtp_password}




kubectl describe -n monitoring pod kube-prometheus-stack-grafana-0




  Warning  FailedMount             29s (x18 over 20m)  kubelet                  MountVolume.SetUp failed for volume "grafana-secret" : secret "grafana-secret" not found


the setup script fails as it does not have a volume secret yet need to set this up from its dir (secrets manager) can spinup via setup-no-json-temp.sh

script here is  a useful guide to this after end of script

it will spin up a useful test now need to integrate the custom json starting with the secret volume also the email is here too



---




following
https://medium.com/@joudwawad/comprehensive-beginners-guide-to-kube-prometheus-in-kubernetes-monitoring-alerts-integration-4ade4fa8fa8c
email could be a dkim etc hostname mail server


This looks very useful





Users on EKS, GKE, or similar services might encounter additional alerts KubeSchedulerDown and KubeControllerManagerDown. These are common because the control plane nodes in managed services aren’t visible to Prometheus. To address this:
1. Create a values.yaml file with the following content:

kubeScheduler:
  enabled: false
kubeControllerManager:
  enabled: false

2. Update your installation using:

helm upgrade -f values.yaml kube-prometheus prometheus-community/kube-prometheus-stack -n monitoring

Or incorporate these settings during initial installation:

helm install -f values.yaml kube-prometheus prometheus-community/kube-prometheus-stack -n monitoring

After applying these changes and waiting a few minutes, the additional alerts should resolve. 😸



need to apply the rest of this too custom metrics and service metrics 


---

add in slack secret using file system ref and a secret



todo add in secret via volume and integrate custom-moved.json.moved as this has lots of helpful content




---

=== Add secret from fixed for testing discarding the custom json values temporarily as a test as this custom breaks on the secret provison currently



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


