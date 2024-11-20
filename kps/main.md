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



