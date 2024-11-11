#!/bin/bash


#!/bin/bash




cd ../


export cluster_name=$(terraform output cluster_name| tr -d '"')


cd -



echo use the correct AWS profile
export AWS_PROFILE=eks
# todo fix the default



echo deleting everything

kubectl delete -f .


:
