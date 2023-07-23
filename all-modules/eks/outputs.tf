
output "worker" {
  value = aws_eks_node_group.worker-node-group.id
}

output eksEndpoint {
    value = aws_eks_cluster.ekscluster.endpoint
}
output "certificate_authority" {
  value = aws_eks_cluster.ekscluster.certificate_authority[0].data
}
output "eksname" {
  value = aws_eks_cluster.ekscluster.name
}
output "cluster_id" {
  value = aws_eks_cluster.ekscluster.cluster_id
}
output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.ekscluster.identity[0].oidc[0].issuer
}