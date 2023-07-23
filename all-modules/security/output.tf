output "eks-secgrp" {
  value = aws_security_group.eks_cluster.id
}

output "ec2-secgrp" {
  value = aws_security_group.ec2-sg.id
}
