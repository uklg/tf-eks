resource "aws_iam_user_policy_attachment" "attach-1" {
  user = "eks"
  policy_arn = aws_iam_policy.eks-cluster-tf.arn
}


resource "aws_iam_user_policy_attachment" "attach-2" {
  user = "eks"
  policy_arn = aws_iam_policy.eks-lbc-policy-tf.arn
}



resource "aws_iam_user_policy_attachment" "attach-3" {
  user = "eks"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
