#!/bin/bash


echo patch the server with ignore several aws metrics that eks means they should be disabled

helm upgrade -f values.yaml kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring

