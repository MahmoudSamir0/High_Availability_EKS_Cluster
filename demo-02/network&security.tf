module "network" {
  source          = "../all-modules/network"
  subnet_name_az1 = ["public_subnet_az1", "private_subnet_az1"]
  subnet_id_az1   = ["10.0.0.0/24", "10.0.1.0/24"]
  subnet_id_az2   = ["10.0.3.0/24", "10.0.4.0/24"]
  subnet_name_az2 = ["public_subnet_az2", "private_subnet_az2"]
  nat-name        = "nat-ec1"
  route-nat       = "myprivate_nat-1"
  rout-public     = "Public Route Table"
  internet-get    = "internet-getway"
  true-and-false  = ["true", "false"]
}
module "security" {
  source = "../all-modules/security"
  vpc-id = module.network.vpc
}
