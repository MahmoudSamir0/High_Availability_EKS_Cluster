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
