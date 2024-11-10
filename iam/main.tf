resource "aws_iam_user_policy_attachment" "attach-1" {
  #user       = aws_iam_user.user.name
  user = "eks"
  policy_arn = aws_iam_policy.eks-cluster-tf.arn
}
