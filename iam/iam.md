need to use iam user here with full iam permissiongs in that users profile

this user does not have enough permissions to create the eksc cluster the eks user and aws profile is used for that


# used for spinning up eks cluster with correct permissions

users
  eks
    policy name:
      AmazonRoute53FullAccess (aws managed)
      eks-cluster (custom)
      ekslbcpolicy custom)

    

these policies need to be added to the eks user


route 53 full access can this be reduced


attach policy directly to eks user



This is a prereq for the eks cluster spin up and operation
add these before running the eks cluster provision either module or in dir


in the .aws is two files


~/.aws/credentials

[eks]
aws_access_key_id = ____PFMF
aws_secret_access_key = xxxx


need to create this user  in aws console 
permissions IAMFullAccess


[iam]
aws_access_key_id = ____Q77A
aws_secret_access_key = xxxx



