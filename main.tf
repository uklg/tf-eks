# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "education-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  enable_irsa     = true # default 

  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    },
  #  aws-ebs-csi-driver2 = {
  #    service_account_role_arn = module.irsa-myapp_secrets.iam_role_arn
  #  }
    
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    /*
    These instances will be available like the other groups including spot groups if set can have more than one
    one = {
      name = "node-group-1"

      # this is most cost effective family. bring down to medium if can
      # arm and needs work
      #instance_types = ["t4g.large"]
      instance_types = ["t3.medium"]


      min_size     = 1
      max_size     = 2
      desired_size = 1

     */

#    two = {
#      name = "node-group-2"
#
#      instance_types = ["t3.small"]
#
#      min_size     = 1
#      max_size     = 2
#      desired_size = 1
#    }
  }
    self_managed_node_groups = {

    default_node_group = {
      create = false
    }

    # fulltime-az-a = {
    #   name                 = "fulltime-az-a"
    #   subnets              = [module.vpc.private_subnets[0]]
    #   instance_type        = "t3.medium"
    #   desired_size         = 1
    #   bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=normal'"
    # }

    spot-az-a = {
      name       = "spot-az-a"
      # this is cost effective but can be pulled from cluster quickly if demanded
      subnet_ids = [module.vpc.private_subnets[0]] # only one subnet to simplify PV usage
      # availability_zones = ["${var.region}a"] # conflict with previous option. TODO try subnet_ids=null at creation (because at modification it fails)

      desired_size         = 1
      min_size             = 1
      max_size             = 2
      bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 0
          spot_allocation_strategy                 = "lowest-price" # "capacity-optimized" described here: https://aws.amazon.com/blogs/compute/introducing-the-capacity-optimized-allocation-strategy-for-amazon-ec2-spot-instances/
        }

        override = [
          {
            instance_type     = "t3.medium"
            weighted_capacity = "1"
          },
        ]
      }

    }

  }


}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}



###

resource "aws_iam_policy" "myapp_secrets" {
  #name = "${local.sgId.cluster_name}-myapp-secrets" #todo
  name = "nginx-deployment-policy-t"



   policy           = jsonencode(
       {
           Statement = [
               {
                   Action   = [
                       "secretsmanager:GetSecretValue",
                       "secretsmanager:DescribeSecret",
                    ]
                   Effect   = "Allow"
                   Resource = ["arn:*:secretsmanager:*:*:secret:Blahsecret2-??????"]
               },
           ]
           Version   = "2012-10-17"
       }
   )


}




#data "aws_iam_policy" "ebs_policy" {
#  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#}




module "irsa-myapp_secrets" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "myapp-secrets-t"
  #role_name                     = "AmazonEKSRolemyapp_secrets-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [aws_iam_policy.myapp_secrets.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa2"]
  # oidc_fully_qualified_subjects = ["system:serviceaccount:default:nginx-deployment-sa"]

  # todo fix this ref if it works
  # provider_url = "oidc.eks.eu-west-1.amazonaws.com/id/BA9E170D464AF7B92084EF72A69B9DC8"
}



module "iam_eks_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "myapp-secrets-t2"

  role_policy_arns = {
    # policy = "arn:aws:iam::012345678901:policy/myapp"
    policy = aws_iam_policy.myapp_secrets.arn
  }

  oidc_providers = {
    one = {
     # provider_arn               = "arn:aws:iam::012345678901:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/5C54DDF35ER19312844C7333374CC09D"
      provider_arn = module.eks.cluster_oidc_issuer_url
      namespace_service_accounts = ["default:my-app-staging", "canary:my-app-staging"]
    }
    #two = {
    #  provider_arn               = "arn:aws:iam::012345678901:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/5C54DDF35ER54476848E7333374FF09G"
    #  namespace_service_accounts = ["default:my-app-staging"]
    #}
  }
}








###


resource "null_resource" "udpdate_ec2" {

  # Using triggers to force execution on every apply

  triggers = {
    # always run this instead of just once
    #always_run = timestamp()

  }

  provisioner "local-exec" {

    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
    
    #command = module.eks.cluster_name

  }
#  depends_on = [module.null_resource.udpdate_ec2]
  depends_on = [module.eks]
}

