# create the EKS cluster.
resource "aws_eks_cluster" "ekscluster" {
 name = var.eksName
 role_arn = var.eks-role
 vpc_config {
  subnet_ids = var.subnet-id
  endpoint_private_access = true
  endpoint_public_access  = false
  security_group_ids = [ var.eks-secgrp ]
 }
 # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
 depends_on = [
  var.eks-role,
 ]
}



# create the worker nodes

 resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.ekscluster.name
  node_group_name = var.node_group_name
  node_role_arn  =  var.worker
  subnet_ids   = var.subnet-id
  instance_types = ["t2.medium"]
 

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
# Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
# Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

  depends_on = [
   var.worker
  ]
 }

