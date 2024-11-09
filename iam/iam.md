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
