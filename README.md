This installs EKS and working LBC



# Learn Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.


Cluster is installed and is accessbile before LBC is instalede with normal load balacer



LBC

Cluster has to be able to  talk to OIDC (that i turned on by default)  to via a role attached to cluster this lbc does this for us.

It mutates requests to crteate ingress and services so they go go one ALB if desired and services can share ALBS. Annototions allow public or private conttrollers.

