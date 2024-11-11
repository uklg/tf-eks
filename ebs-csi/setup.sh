#!/bin/bash




cd ../


export cluster_name=$(terraform output cluster_name| tr -d '"')




echo check to see if ebi-csi driver is installed in the eks cluster


aws eks describe-addon --cluster-name education-eks-OQCBxcyH --addon-name aws-ebs-csi-driver


