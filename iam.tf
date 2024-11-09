# aws_iam_policy.eks-cluster:
resource "aws_iam_policy" "eks-cluster-tf" {
    name = "eks-cluster-tf"
    policy           = jsonencode(
        {
            Statement = [
                {
                    Action   = [
                        "autoscaling:AttachInstances",
                        "autoscaling:CreateAutoScalingGroup",
                        "autoscaling:CreateLaunchConfiguration",
                        "autoscaling:CreateOrUpdateTags",
                        "autoscaling:DeleteAutoScalingGroup",
                        "autoscaling:DeleteLaunchConfiguration",
                        "autoscaling:DeleteTags",
                        "autoscaling:Describe*",
                        "autoscaling:DetachInstances",
                        "autoscaling:SetDesiredCapacity",
                        "autoscaling:UpdateAutoScalingGroup",
                        "autoscaling:SuspendProcesses",
                        "ec2:AllocateAddress",
                        "ec2:AssignPrivateIpAddresses",
                        "ec2:Associate*",
                        "ec2:AttachInternetGateway",
                        "ec2:AttachNetworkInterface",
                        "ec2:AuthorizeSecurityGroupEgress",
                        "ec2:AuthorizeSecurityGroupIngress",
                        "ec2:CreateDefaultSubnet",
                        "ec2:CreateDhcpOptions",
                        "ec2:CreateEgressOnlyInternetGateway",
                        "ec2:CreateInternetGateway",
                        "ec2:CreateNatGateway",
                        "ec2:CreateNetworkInterface",
                        "ec2:CreateRoute",
                        "ec2:CreateRouteTable",
                        "ec2:CreateSecurityGroup",
                        "ec2:CreateSubnet",
                        "ec2:CreateTags",
                        "ec2:CreateVolume",
                        "ec2:CreateVpc",
                        "ec2:CreateVpcEndpoint",
                        "ec2:DeleteDhcpOptions",
                        "ec2:DeleteEgressOnlyInternetGateway",
                        "ec2:DeleteInternetGateway",
                        "ec2:DeleteNatGateway",
                        "ec2:DeleteNetworkInterface",
                        "ec2:DeleteRoute",
                        "ec2:DeleteRouteTable",
                        "ec2:DeleteSecurityGroup",
                        "ec2:DeleteSubnet",
                        "ec2:DeleteTags",
                        "ec2:DeleteVolume",
                        "ec2:DeleteVpc",
                        "ec2:DeleteVpnGateway",
                        "ec2:Describe*",
                        "ec2:DetachInternetGateway",
                        "ec2:DetachNetworkInterface",
                        "ec2:DetachVolume",
                        "ec2:Disassociate*",
                        "ec2:ModifySubnetAttribute",
                        "ec2:ModifyVpcAttribute",
                        "ec2:ModifyVpcEndpoint",
                        "ec2:ReleaseAddress",
                        "ec2:RevokeSecurityGroupEgress",
                        "ec2:RevokeSecurityGroupIngress",
                        "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                        "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
                        "ec2:CreateLaunchTemplate",
                        "ec2:CreateLaunchTemplateVersion",
                        "ec2:DeleteLaunchTemplate",
                        "ec2:DeleteLaunchTemplateVersions",
                        "ec2:DescribeLaunchTemplates",
                        "ec2:DescribeLaunchTemplateVersions",
                        "ec2:GetLaunchTemplateData",
                        "ec2:ModifyLaunchTemplate",
                        "ec2:RunInstances",
                        "eks:CreateCluster",
                        "eks:DeleteCluster",
                        "eks:DescribeCluster",
                        "eks:ListClusters",
                        "eks:UpdateClusterConfig",
                        "eks:UpdateClusterVersion",
                        "eks:DescribeUpdate",
                        "eks:TagResource",
                        "eks:UntagResource",
                        "eks:ListTagsForResource",
                        "eks:CreateFargateProfile",
                        "eks:DeleteFargateProfile",
                        "eks:DescribeFargateProfile",
                        "eks:ListFargateProfiles",
                        "eks:CreateNodegroup",
                        "eks:DeleteNodegroup",
                        "eks:DescribeNodegroup",
                        "eks:ListNodegroups",
                        "eks:UpdateNodegroupConfig",
                        "eks:UpdateNodegroupVersion",
                        "iam:AddRoleToInstanceProfile",
                        "iam:AttachRolePolicy",
                        "iam:CreateInstanceProfile",
                        "iam:CreateOpenIDConnectProvider",
                        "iam:CreateServiceLinkedRole",
                        "iam:CreatePolicy",
                        "iam:CreatePolicyVersion",
                        "iam:CreateRole",
                        "iam:DeleteInstanceProfile",
                        "iam:DeleteOpenIDConnectProvider",
                        "iam:DeletePolicy",
                        "iam:DeletePolicyVersion",
                        "iam:DeleteRole",
                        "iam:DeleteRolePolicy",
                        "iam:DeleteServiceLinkedRole",
                        "iam:DetachRolePolicy",
                        "iam:GetInstanceProfile",
                        "iam:GetOpenIDConnectProvider",
                        "iam:GetPolicy",
                        "iam:GetPolicyVersion",
                        "iam:GetRole",
                        "iam:GetRolePolicy",
                        "iam:List*",
                        "iam:PassRole",
                        "iam:PutRolePolicy",
                        "iam:RemoveRoleFromInstanceProfile",
                        "iam:TagOpenIDConnectProvider",
                        "iam:TagRole",
                        "iam:UntagRole",
                        "iam:UpdateAssumeRolePolicy",
                        "logs:CreateLogGroup",
                        "logs:DescribeLogGroups",
                        "logs:DeleteLogGroup",
                        "logs:ListTagsLogGroup",
                        "logs:PutRetentionPolicy",
                        "kms:CreateAlias",
                        "kms:CreateGrant",
                        "kms:CreateKey",
                        "kms:DeleteAlias",
                        "kms:DescribeKey",
                        "kms:GetKeyPolicy",
                        "kms:GetKeyRotationStatus",
                        "kms:ListAliases",
                        "kms:ListResourceTags",
                        "kms:ScheduleKeyDeletion",
                        "kms:TagResource",
                        "logs:TagResource",
                        "ec2:DeleteNetworkAclEntry",
                        "eks:CreateAccessEntry",
                        "ec2:CreateNetworkAclEntry",
                        "eks:DescribeAddonVersions",
                        "eks:DescribeAccessEntry",
                        "eks:DeleteAccessEntry",
                        "eks:AssociateAccessPolicy",
                        "eks:ListAssociatedAccessPolicies",
                        "eks:DisassociateAccessPolicy",
                        "eks:CreateAddon",
                        "eks:DescribeAddon",
                        "eks:DeleteAddon",
                        "kms:ScheduleKeyDeletion",
                        "iam:AttachUserPolicy",
                        "cloudformation:ListStacks",
                        "cloudformation:*",
                        "sts:GetCallerIdentity",
                        "acm:RequestCertificate",
                        "acm:ListTagsForCertificate",
                        "acm:DeleteCertificate",
                    ]
                    Effect   = "Allow"
                    Resource = "*"
                    Sid      = "VisualEditor0"
                },
            ]
            Version   = "2012-10-17"
        }
    )
}
