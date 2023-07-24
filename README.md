# High_Availability_EKS_Cluster
Goal of this project is to deploy scalable, highly available and secured asp.net application on EKS cluster and provide application access to the end users from public internet.
## Overview
This project uses Terraform to create the following AWS resources:

- VPC
- Internet Gateway
- Public Route Table
- Private Route Table
- NatGateway and ElasticIP 
- Security Groups 
- Node group
- EKS role and policy 
- Node Group Role and Policy 
- EKS Cluster
- rout53
- S3 bucket
- DynamoDB
-  load balancer
-  SSL Certificate using certificate manager
## Infrastructure Architecture
![wks](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/blob/master/High_Availability_EKS_Cluster.png)
## Requirements
* [Terraform](https://www.terraform.io/) - Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.
* [Amazon AWS Account](https://aws.amazon.com/it/console/) - Amazon AWS account with billing enabled

## Before you start
Note that this tutorial uses AWS resources that are outside the AWS [free tier](https://aws.amazon.com/pricing/?aws-products-pricing.sort-by=item.additionalFields.productNameLowercase&aws-products-pricing.sort-order=asc&awsf.Free%20Tier%20Type=*all&awsf.tech-category=*all), so be careful! 

### Step-by-step instructions:

To get started with this project, clone this repository to your local machine:
```
$ git clone https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster.git
```
#### 1.  Go into 'terraform' folder.
```
cd ~/High_Availability_EKS_Cluster
```
#### 2.  Specify things like Access and secret key in some ways:

*Option 1* - Specify it directly in the provider (not recommended)

```
provider "aws" {
  region     = "us-west-1"
  access_key = "myaccesskey"
  secret_key = "mysecretkey"
}
```
Obviously, it has some downsides, like, you would need to put your credentials into TF script, which is very bad idea, hence it's highly NOT recommended.


*Option 2* - Using the shared_credentials_file to pass environment credentials

```
provider "aws" {
  region = "${var.region}"
  shared_credentials_file  = "${var.cred-file}"
}

```

where variable `${var.cred-file}` looks like:

```
variable "cred-file" {
  default = "~/.aws/credentials"
}

```

Node: `~/.aws/credentials` points to credentials file located in your home directory. For development purposes, this might be fine, but for PROD deployment, this will needs to be replaced with call to Vault.

File `~/.aws/credentials` has following format:

```
[default]
aws_access_key_id = <your access key>
aws_secret_access_key = <your secret key>
```

Of course, there are bunch of other options to manage secrets and keys, but this is not the objective of this repo (although, it's on TODO list).

The second option is *recommended* because you don’t need to expose your secrets on TF script. And, again, proper integration with the vault and KMS is on my TODO.

Hence, `_main.tf` would look like:

```
provider "aws" {
  region = "${var.region}"
  shared_credentials_file  = "${var.cred-file}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.key_name}"
  public_key = "${file("dev_key.pub")}"
}
```
#### 3. Directory structure would look like this:
```
| => tree
.
├── all-modules
│   ├── cluster-autoscaler
│   │   ├── helm.tf
│   │   ├── iam.tf
│   │   ├── namespace.tf
│   │   └── variables.tf
│   ├── dynamodb
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── IAM
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── varibles.tf
│   ├── network
│   │   ├── elastic.tf
│   │   ├── internet.tf
│   │   ├── nat.tf
│   │   ├── output.tf
│   │   ├── rout-privet.tf
│   │   ├── subnet.tf
│   │   ├── variables.tf
│   │   └── vpc.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── security
│       ├── output.tf
│       ├── securityg.tf
│       └── variable.tf
├── demo-01
│   ├── dynamodb.tf
│   ├── provider.tf
│   ├── README.md
│   ├── s3.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
├── demo-02
│   ├── backend.tf
│   ├── domainssl.tf
│   ├── ekscluster.tf
│   ├── helm.tf
│   ├── iam.tf
│   ├── kubernetes.tf
│   ├── network&security.tf
│   ├── provider.tf
│   ├── README.md
│   ├── terraform.tfstate
│   ├── terraform.tfvars
│   └── variables.tf
├── High_Availability_EKS_Cluster.png
├── README.md
└── Screenshot from 2023-07-23 23-15-22.png

10 directories, 48 files
```
Let's discuss our files
##### 1. dynamodb dir in all-modules 
in *main.tf*
```hcl
resource "aws_dynamodb_table" "name" {
  name         = var.dynamodb-name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "lockID"

  attribute {
    name = "lockID"
    type = "S"
  }
}
```
in variables.tf
```hcl
variable "dynamodb-name" {
  
}
```
In this way we will create a table in dynamoDB called you can choose a different name using dynamodb-name variables  , unlike the bucket, the name of the table is not global and therefore there can be multiple tables with the same name, as long as are not in the same region of the same account). The primary key to be used to lock the state in dynamoDB must be called LockID and must be a “string” type (S).

##### 2. s3 dir in all-modules 
in *main.tf*
```hcl
resource "aws_s3_bucket" "tf-state" {
  bucket = var.bucket-name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "name" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = var.status
  }
}
```
in variables.tf
```hcl
variable "bucket-name" {
  
}

variable "status" {
  
}
```
in output.tf
```hcl
output "bucket-arn" {
  value = aws_s3_bucket.tf-state.arn
}

output "bucket-name" {
  value = aws_s3_bucket.tf-state.bucket
}
output "bucket-id" {
  value = aws_s3_bucket.tf-state.id
}       
output "domain" {
  value = aws_s3_bucket.tf-state.bucket_regional_domain_name
}
```
In this way we will create an s3 bucket called  (you can call it as you want useing bucket-name variable but remembering that the names of the s3 buckets in AWS are global, which means that it is not possible to use a name that has been used by someone else). In this case I decided to enable versioning so that every revision of the state file is stored, and is possible to roll back to an older version if something goes wrong. I decided to encrypt the contents of the bucket as the state file saves the infrastructure information and therefore also the sensitive data in plain-text. I also decided to enable the lock of objects in order to avoid deletion or overwriting.
##### 3. network dir in all-modules 
in vpc.tf
```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
```
here we want to create 1 vpc cidr block (10.0.0.0/16)


in subnet.tf
```hcl
resource "aws_subnet" "mysub_az1" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.subnet_id_az1)
  cidr_block              = var.subnet_id_az1[count.index]
  map_public_ip_on_launch = var.true-and-false[count.index]
  availability_zone       = "us-east-1a"
  tags = {
    Name = var.subnet_name_az1[count.index]
  }
}

resource "aws_subnet" "mysub_az2" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.subnet_id_az2)
  cidr_block              = var.subnet_id_az2[count.index]
  map_public_ip_on_launch = var.true-and-false[count.index]
  availability_zone       = "us-east-1b"
  tags = {
    Name = var.subnet_name_az2[count.index]
  }
}
```
we want to create subnet in each zone any number we need and we can choose if we want that subnet to be private or to be public

in internet.tf

```hcl
resource "aws_internet_gateway" "it" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.internet-get
  }
}
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.it.id
  }
  tags = {
    Name = var.rout-public
  }
}


resource "aws_route_table_association" "myrout-a" {
  subnet_id      = aws_subnet.mysub_az1[0].id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_route_table_association" "myrout-b" {
  subnet_id      = aws_subnet.mysub_az2[0].id
  route_table_id = aws_route_table.myroute.id
}
```
we create internet gateway and apply route table for each public subnet


in elastic.tf 
```hcl
resource "aws_eip" "elastic_id" {
  vpc = true
   tags = {
    Name = "master_eip"
  }
}
```
we need elastic ip for natgeteway 

in nat.tf 
```hcl
resource "aws_nat_gateway" "gw" {
  subnet_id     = aws_subnet.mysub_az1[0].id
  allocation_id = aws_eip.elastic_id.id

  tags = {
    "name" = var.nat-name
  }
}
```
natgateway for private subnet to connect to internet

in rout-privet.tf
```hcl
resource "aws_route_table" "privett" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = {
    Name = var.route-nat
  }
}

resource "aws_route_table_association" "privett-a" {
  subnet_id      = aws_subnet.mysub_az1[1].id
  route_table_id = aws_route_table.privett.id
}
```

in variables.tf

```hcl
variable "subnet_name_az1" {
  type = list(any)
}
variable "subnet_name_az2" {
  type = list(any)
}
variable "subnet_id_az1" {
  type = list(any)
}

variable "subnet_id_az2" {
  type = list(any)
}
variable "nat-name" {
  type = string

}
variable "route-nat" {
  type = string
}
variable "rout-public" {
  type = string
}
variable "internet-get" {
  type = string
}

variable "true-and-false" {
  type = list(any)
}

```
in output
```hcl
output "public_subnet_ip_az1" {
  value = aws_subnet.mysub_az1[0].id

}
output "public_subnet_ip_az2" {
  value = aws_subnet.mysub_az2[0].id

}
output "private_subnet_ip_az1" {
  value = aws_subnet.mysub_az1[1].id

}
output "private_subnet_ip_az2" {
  value = aws_subnet.mysub_az2[1].id

}
output "vpc" {
  value = aws_vpc.myvpc.id
}

```
##### 4. security dir in all-modules 

in securityg.tf

```hcl
resource "aws_security_group" "eks_cluster" {
  name_prefix = "eks_cluster_"
  description = "Security group for EKS cluster"
  vpc_id = var.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

```
we create Security group for EKS cluster 


in variable.tf

```hcl
variable "vpc-id" {
  
}

```
```hcl
output "eks-secgrp" {
  value = aws_security_group.eks_cluster.id
}

```
##### 5. IAM dir in all-modules 
in main.tf 

```hcl

resource "aws_iam_role" "eks-iam-role" {
 name = "eks-iam-role"

 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF

}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role    = aws_iam_role.eks-iam-role.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role    = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_policy" "ecr-cluster-access" {
  name        = "eks-ecr-access"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:DeleteRepository",
          "ecr:BatchDeleteImage",
          "ecr:SetRepositoryPolicy",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:GetRegistryPolicy",
          "ecr:PutRegistryPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecr-cluster-access" {
  policy_arn = aws_iam_policy.ecr-cluster-access.arn
  role       = aws_iam_role.eks-iam-role.name
}


resource "aws_iam_role" "workernodes" {
  name = "eks-node-group-example"
 
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 }

 resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.workernodes.name
 }
 
 resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role    = aws_iam_role.workernodes.name
 }
```
 The two policies allow you to properly access EC2 instances,Allow EKS cluster access to ECR registry, Set up an IAM role for the worker nodes.
 
in output.tf 

```hcl
output "worker-role" {
  value = aws_iam_role.workernodes.arn
}

output "eks-role" {
  value = aws_iam_role.eks-iam-role.arn
}
```


##### 6. eks dir in all-modules 

in main.tf

```hcl
resource "aws_eks_cluster" "ekscluster" {
 name = var.eksName
 role_arn = var.eks-role
 vpc_config {
  subnet_ids = var.subnet-id
  endpoint_private_access = true
  endpoint_public_access  = false
  security_group_ids = [ var.eks-secgrp ]
 }

 depends_on = [
  var.eks-role,
 ]
}

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
  depends_on = [
   var.worker
  ]
 }

```
create eks cluster with node you can change number of node in every subnet 

in output.tf

```hcl

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

```

in variables.tf

```hcl
variable "subnet-id" {
  type = list
}

variable "vpc-id" {
  
}
variable "eks-secgrp" {
  
}

variable "eks-role" {
  
}

variable "worker" {
  
}
variable "eksName" {
  
}
variable "desired_size" {
  
}
variable "max_size" {
  
}
variable "min_size" {
  
}
variable "node_group_name" {
  
}
```

##### 7. cluster-autoscaler dir in all-modules 

you can use module for [autoscale](https://registry.terraform.io/modules/DNXLabs/eks-cluster-autoscaler/aws/latest) node from terraform
but here there is problem with this module so i edit it  to use it 

##### 8.demo-01
in s3.tf
setup the remote state bucket
```hcl
module "s3-bucket" {
  source      = "../all-modules/s3/"
  bucket-name = "terraform-update-and-run-state"
  status      = "Enabled"
}
```

Terraform S3 backend allows you to define a dynamodb table that can be used to store state locking status. To create and use a table set dynamodb_state_locking to true.

```hcl
module "dynamo" {
  source        = "../all-modules/dynamodb"
  dynamodb-name = "terraform-update-and-run-state"
}
```


##### 9.demo-02

in backend.tf

```hcl
terraform {
  backend "s3" {
    #put your s3 here
    bucket = "terraform-update-and-run-state"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"


    #put your dynamodb here
    dynamodb_table = "terraform-update-and-run-state"
    encrypt         = true
  }
}

```
in demo-01 we create s3 bucket and dynamodb to store our tfstate file here we create our backend to upload the tfstate

in network&security.tf

```hcl
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

```
in iam.tf 

```hcl
module "IAM" {
  source = "../all-modules/IAM"
}
resource "aws_iam_openid_connect_provider" "default" {
  url = module.ekscluster.cluster_oidc_issuer_url

  client_id_list = [
"sts.amazonaws.com"]

  thumbprint_list = [ aws_acm_certificate.cert.arn]
}

```


in ekscluster.tf

 ```hcl
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
 ```
 
 in domainssl.tf
 
 
 ```hcl
resource "aws_acm_certificate" "cert" {
  domain_name       = "aspapp.com"
  validation_method = "DNS"

}
resource "aws_route53_zone" "primary" {
  name = "aspapp.com"
}
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.aspapp.com"
  type    = "A"
  ttl     = "300"
  records = [kubernetes_service.aspapp_service.status.0.load_balancer.0.ingress.0.hostname]
}
 ```
 
 in kubernetes.tf
 
 ```hcl
 provider "kubernetes" {
  host                   = module.ekscluster.eksEndpoint
  cluster_ca_certificate = base64decode(module.ekscluster.certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.ekscluster.eksname ]
    command     = "aws"
  }
}

resource "kubernetes_deployment" "aspapp" {
  
  metadata {
    name = "aspapp"
    labels = {
      app = "aspapp"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "aspapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "aspapp"
        }
      }

      spec {
        container {
          image = "2534m/aspnetapp:latest"
          name  = "aspapp"

          port {
            container_port = 80
          }
        }
      }
    }
  }
depends_on = [ module.ekscluster ]
}

resource "kubernetes_service" "aspapp_service" {
  metadata {
    name = "aspapp"
  }

  spec {
    selector = {
      app = kubernetes_deployment.aspapp.spec.0.template.0.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  depends_on = [ kubernetes_deployment.aspapp ]
}

resource "kubernetes_horizontal_pod_autoscaler" "example" {
  metadata {
    name = "aspapp"
  }

  spec {
    min_replicas = 3
    max_replicas = 100

    scale_target_ref {
      kind = "Deployment"
      name = "aspapp"
    }

    metric {
      type = "External"
      external {
        metric {
          name = "latency"
          selector {
            match_labels = {
              lb_name = split("-", split(".", kubernetes_service.aspapp_service.status.0.load_balancer.0.ingress.0.hostname).0).0

            }
          }
        }
        target {
          type  = "Value"
          value = "100"
        }
      }
    }
  }
  depends_on = [ module.ekscluster ]
}


resource "kubernetes_deployment" "sqlserver" {
  metadata {
    name = "sqlserver"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "sqlserver"
      }
    }

    template {
      metadata {
        labels = {
          app = "sqlserver"
        }
      }

      spec {
        container {
          image = "microsoft/mssql-server:2017-latest"  
          name  = "sqlserver"

          port {
            container_port = 1433
          }

          env {
            name = "ACCEPT_EULA"
            value = "Y"
          }

          env {
            name = "SA_PASSWORD"
            value = "12345mahmoud" 
          }
        }
      }
    }
  } 
    depends_on = [ module.ekscluster ]

}

resource "kubernetes_service" "sqlserver" {
  metadata {
    name = "sqlserver"
  }

  spec {
    selector = {
      app = kubernetes_deployment.sqlserver.spec.0.template.0.metadata[0].labels.app
    }

    port {
      port        = 1433
      target_port = 1433 
    }
  }
    depends_on = [ module.ekscluster ]
}

 ```
here we install our app  and  our database sql sever using kubernetes provider but is not best practice to use it we recommend to use yml file 
 
 in helm.tf
 
 ```hcl
 provider "helm" {
  kubernetes {
 host                   = module.ekscluster.eksEndpoint
  cluster_ca_certificate = base64decode(module.ekscluster.certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.ekscluster.eksname ]
    command     = "aws"
  }
  }
}
module "cluster_autoscaler" {
  source = "../all-modules/cluster-autoscaler"

  enabled = true

  cluster_name                     = module.ekscluster.cluster_id
  cluster_identity_oidc_issuer     = module.ekscluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = aws_iam_openid_connect_provider.default.arn
  aws_region                       = "us-east-1"
}

resource "helm_release" "my-redis-cache" {
  name       = "my-redis-cache"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "17.13.2"

  set {
    name  = "cluster.enabled"
    value = "true"
  }

set {
  name = "replica.autoscaling"
  value = "true"
}
set {
  name = "global.redis.password"
  value = "12345mahmoud"
}
set {
  name = "auth.password"
  value = "12345mahmoud"
}
depends_on = [ module.ekscluster ]
}

resource "helm_release" "my-mongodb" {
  name       = "my-mongodb"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mongodb"
  version    = "13.16.0"

  set {
    name  = "auth.rootPassword"
  value = "12345mahmoud"
  }

  set {
    name  = "auth.rootUser"
    value = "mahmoud"
  }
  depends_on = [ module.ekscluster ]

}
 ```
 here we install our [mongodb](https://artifacthub.io/packages/helm/bitnami/mongodb) and [redis](https://artifacthub.io/packages/helm/bitnami/redis) cache using helm release you can only edit only values  

 
 ## Setup 
 begin from [demo-01](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/tree/master/demo-01) 
 
