#!/bin/bash

helm uninstall kube-prometheus-stack -n monitoring

kubectl delete ns monitoring


