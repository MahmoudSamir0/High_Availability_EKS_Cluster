output "worker-role" {
  value = aws_iam_role.workernodes.arn
}

output "eks-role" {
  value = aws_iam_role.eks-iam-role.arn
}