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


