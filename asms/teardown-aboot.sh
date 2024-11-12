#!/bin/bash


export AWS_PROFILE=eks

export REGION=eu-north-1

cd ../
export CLUSTERNAME=$(terraform output cluster_name| tr -d '"')
cd -



echo list all helm deployments in all namespaces

helm list -A 
helm repo list


helm uninstall -n kube-system csi-secrets-store


helm repo remove secrets-store-csi-driver 



kubectl delete -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml



arn=$(aws --region "$REGION" secretsmanager list-secrets|grep ARN|cut -d '"' -f 4)


echo delete first secret found. 
echo skipping as secret cannot be remade easily
# aws --region "$REGION" secretsmanager  delete-secret  --secret-id $arn


#aws --region "$REGION" secretsmanager  create-secret --name MySecret --secret-string '{"username":"memeuser", "password":"hunter2"}'



#An error occurred (AccessDeniedException) when calling the CreateSecret operation: User: arn:aws:iam::905418418476:user/eks is not authorized to perform: secretsmanager:CreateSecret on resource: MySecret because no identity-based policy allows the secretsmanager:CreateSecret action



# added eks policy SecretsManagerReadWrite temp


echo 'Create an access policy for the pod scoped down to just the secrets it should have and save the policy ARN in a shell variable:'






# all ready done so can not do this

#eksctl utils associate-iam-oidc-provider --region="$REGION" --cluster="$CLUSTERNAME" --approve # Only run this once


eksctl delete iamserviceaccount --name nginx-deployment-policy --region="$REGION" --cluster "$CLUSTERNAME" 
#nginx-deployment-sa



arn2=$(aws --region "$REGION" iam list-policies --query 'Policies[?PolicyName==`nginx-deployment-policy`]'|grep Arn|cut -d '"' -f4)

aws --region "$REGION" iam delete-policy --policy-arn $arn2


echo An error occurred (DeleteConflict) when calling the DeletePolicy operation: Cannot delete a policy attached to entities.





#aws --region "$REGION" iam  list-entities-for-policy --policy-arn $arn2 
#{
#    "PolicyGroups": [],
#    "PolicyUsers": [],
#    "PolicyRoles": [
#        {
#            "RoleName": "eksctl-education-eks-i6RbpLtk-addon-iamservic-Role1-U0gtvp5kV0nP",
#            "RoleId": "AROA5FTZEVEWMQ5LBLN75"
#        }
#    ]
#}

#
#  detach-role-policy
# --role-name <value>
# --policy-arn <value>

# detach policy from role



#aws --region "$REGION" iam list-policies --query 'Policies[?PolicyName==`nginx-deployment-policy`

attached_role_name=$(aws --region "$REGION" iam  list-entities-for-policy --policy-arn $arn2 |grep RoleName|cut -d '"' -f 4)


aws --region "$REGION" iam detach-role-policy --role-name $attached_role_name --policy-arn $arn2





#eksctl create iamserviceaccount --name nginx-deployment-sa --region="$REGION" --cluster "$CLUSTERNAME" --attach-policy-arn "$POLICY_ARN" --approve --override-existing-serviceaccount




kubectl delete -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/examples/ExampleSecretProviderClass.yaml

kubectl delete -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/examples/ExampleDeployment.yaml






kubectl exec -it $(kubectl get pods | awk '/nginx-deployment/{print $1}' | head -1) cat /mnt/secrets-store/MySecret; echo


echo should be no '{"username":"memeuser", "password":"hunter2"}'




