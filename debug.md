if the teardown breaks due to dependency issue delete it manually in aws terminal and add some time betweeen teardown operations

if the bulild fals destroy and rebuild the iam folder (unless cluster is in use it may cause issues if the clusters are built or may not)


first increase of time between ops has allowed teardown
will cheeck by tearing down and then do iam bfefore rebulding

 

can add a default sg and attach it to vpc module config may help if needed dependecy issues










