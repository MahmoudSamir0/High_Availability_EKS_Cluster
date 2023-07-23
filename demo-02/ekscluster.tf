module "ekscluster" {
  source = "../all-modules/eks"
  subnet-id=[module.network.private_subnet_ip_az1 ,module.network.private_subnet_ip_az2]
  vpc-id=module.network.vpc
  eks-secgrp=module.security.eks-secgrp
  eks-role=module.IAM.eks-role
  worker=module.IAM.worker-role
  eksName="new_eks"
  desired_size=1
  max_size=1
  min_size=1
  node_group_name="new_node_group"
}