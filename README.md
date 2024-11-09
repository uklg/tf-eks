This installs EKS and working LBC

prerequisites
cd to iam and set this up first or call a module
this will setup the iam required to setup and run the eks cluster



# Learn Terraform - Provision an EKS Cluster

This repo is a companion repo to the [Provision an EKS Cluster tutorial](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks), containing
Terraform configuration files to provision an EKS cluster on AWS.


Cluster is installed and is accessbile before LBC is instalede with normal load balacer



LBC

Cluster has to be able to  talk to OIDC (that i turned on by default when eks cluster is configured here in eks module)  to via a role attached to cluster this lbc does this for us.

It mutates requests to crteate ingress and services so they go go one ALB if desired and services can share ALBS. Annototions allow public or private conttrollers.


Cluster is installed then it depended on by  null exec to update the aws kubectl profile and then  the lbc depends on being able to speak to the cluster and permissions:

add permissions to create and acesss Route 53

Attach the policy to the eks user:

AmazonRoute53FullAccess

If this layered perms chaind does not work need to have lbc in a different folder and install that after but refer to outputs from the first folder and do the cluster first then the aws kubectl update and then the lbc istall. that would be more reliable possibly

Cert-man is being disabled as only ACM and LBC needed to bring up an ALB TLS service in AWS perfectly



Spot instances set up but need extra work for reliability and extra instances to move load too 


ebs driver installed to allow persistance storage enabled 
https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
