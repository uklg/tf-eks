#!/bin/bash


export AWS_PROFILE=eks

export REGION=eu-north-1

secretname=Blahsecret2

helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts

helm install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver

kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

export REGION=eu-north-1

cd ../
export CLUSTERNAME=$(terraform output cluster_name| tr -d '"')
cd -


aws --region "$REGION" secretsmanager  create-secret --name $secretname --secret-string '{"username":"memeuser", "password":"hunter2"}'


#An error occurred (AccessDeniedException) when calling the CreateSecret operation: User: arn:aws:iam::905418418476:user/eks is not authorized to perform: secretsmanager:CreateSecret on resource: MySecret because no identity-based policy allows the secretsmanager:CreateSecret action



# added eks policy SecretsManagerReadWrite temp


echo 'Create an access policy for the pod scoped down to just the secrets it should have and save the policy ARN in a shell variable:'




POLICY_ARN=$(aws --region "$REGION" --query Policy.Arn --output text iam create-policy --policy-name nginx-deployment-policy --policy-document '{
    "Version": "2012-10-17",
    "Statement": [ {
        "Effect": "Allow",
        "Action": ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
        "Resource": ["arn:*:secretsmanager:*:*:secret:Blahsecret2-??????"]
    } ]
}')


# all ready done so can not do this

#eksctl utils associate-iam-oidc-provider --region="$REGION" --cluster="$CLUSTERNAME" --approve # Only run this once


eksctl create iamserviceaccount --name nginx-deployment-sa --region="$REGION" --cluster "$CLUSTERNAME" --attach-policy-arn "$POLICY_ARN" --approve --override-existing-serviceaccounts



kubectl apply -f modified-ExampleSecretProviderClass.yaml

kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/examples/ExampleDeployment.yaml

echo shouul be in pod user /mnt/secretes-store



echo any errors try deleting the ngix policy first


echo here is the secret:


kubectl exec -it $(kubectl get pods | awk '/nginx-deployment/{print $1}' | head -1) cat /mnt/secrets-store/$secretname; echo




#echo '{"username":"memeuser", "password":"hunter2"}'




