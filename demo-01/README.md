# terraform-aws-remote-state-s3-backend

A terraform module to set up [remote state management](https://www.terraform.io/docs/state/remote.html) with [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) for your account. It creates an encrypted S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.
Resources are defined following best practices as described in [the official document](https://www.terraform.io/docs/backends/types/s3.html#multi-account-aws-architecture)
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dynamodb-name | the name  of dynmodb | string | dynamodb-name | yes |
| bucket-name | the name of s3bucket | string | terraform-update-and-run-state | yes |
| Enabled | to enable versioning in s3 bucket | bool | `true` | yes |

## Outputs

| Name | Description |
|------|-------------|
| bucket-arn | The ARN of the bucket  |
| bucket-name | name of bucket, if created |
| bucket-id | name of bucket, if created |
| domain | The bucket region-specific domain name. The bucket domain name including the region name |
#### usage example

setup the remote state bucket
```hcl
module "s3-bucket" {
  source      = "../all-modules/s3/"
  bucket-name = "terraform-update-and-run-state"
  status      = "Enabled"
}
```
you can find s3 module in "../all-modules/s3/" path 

##### dynamodb state locking

Terraform S3 backend allows you to define a dynamodb table that can be used to store state locking status. To create and use a table set dynamodb_state_locking to true.

```hcl
module "dynamo" {
  source        = "../all-modules/dynamodb"
  dynamodb-name = "terraform-update-and-run-state"
}
```
  ## Initialize the directory

When you create a new configuration — or check out an existing configuration
from version control — you need to initialize the directory with `terraform
init`. This step downloads the providers defined in the configuration.

Initialize the directory.

```hcl
terraform init
```
Terraform returns output similar to the following.

```raw
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v4.60.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
### Apply Configuration

 **copy this command**

```hcl
terraform apply 
```
- Terraform will print output similar to what is shown below. We have truncated some of the output for brevity.
- Terraform will prompt you to confirm the operation.
```
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.dynamo.aws_dynamodb_table.name will be created
  + resource "aws_dynamodb_table" "name" {
      + arn              = (known after apply)
      + billing_mode     = "PAY_PER_REQUEST"
      + hash_key         = "lockID"
      + id               = (known after apply)
      + name             = "terraform-update-and-run-state"
      + read_capacity    = (known after apply)
      + stream_arn       = (known after apply)
      + stream_label     = (known after apply)
      + stream_view_type = (known after apply)
      + tags_all         = (known after apply)
      + write_capacity   = (known after apply)

      + attribute {
          + name = "lockID"
          + type = "S"
        }

      + point_in_time_recovery {
          + enabled = (known after apply)
        }

      + server_side_encryption {
          + enabled     = (known after apply)
          + kms_key_arn = (known after apply)
        }

      + ttl {
          + attribute_name = (known after apply)
          + enabled        = (known after apply)
        }
    }

  # module.s3-bucket.aws_s3_bucket.tf-state will be created
  + resource "aws_s3_bucket" "tf-state" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = "terraform-update-and-run-state"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags_all                    = (known after apply)
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule {
          + allowed_headers = (known after apply)
          + allowed_methods = (known after apply)
          + allowed_origins = (known after apply)
          + expose_headers  = (known after apply)
          + max_age_seconds = (known after apply)
        }

      + grant {
          + id          = (known after apply)
          + permissions = (known after apply)
          + type        = (known after apply)
          + uri         = (known after apply)
        }

      + lifecycle_rule {
          + abort_incomplete_multipart_upload_days = (known after apply)
          + enabled                                = (known after apply)
          + id                                     = (known after apply)
          + prefix                                 = (known after apply)
          + tags                                   = (known after apply)

          + expiration {
              + date                         = (known after apply)
              + days                         = (known after apply)
              + expired_object_delete_marker = (known after apply)
            }

          + noncurrent_version_expiration {
              + days = (known after apply)
            }

          + noncurrent_version_transition {
              + days          = (known after apply)
              + storage_class = (known after apply)
            }

          + transition {
              + date          = (known after apply)
              + days          = (known after apply)
              + storage_class = (known after apply)
            }
        }

      + logging {
          + target_bucket = (known after apply)
          + target_prefix = (known after apply)
        }

      + object_lock_configuration {
          + object_lock_enabled = (known after apply)

          + rule {
              + default_retention {
                  + days  = (known after apply)
                  + mode  = (known after apply)
                  + years = (known after apply)
                }
            }
        }

      + replication_configuration {
          + role = (known after apply)

          + rules {
              + delete_marker_replication_status = (known after apply)
              + id                               = (known after apply)
              + prefix                           = (known after apply)
              + priority                         = (known after apply)
              + status                           = (known after apply)

              + destination {
                  + account_id         = (known after apply)
                  + bucket             = (known after apply)
                  + replica_kms_key_id = (known after apply)
                  + storage_class      = (known after apply)

                  + access_control_translation {
                      + owner = (known after apply)
                    }

                  + metrics {
                      + minutes = (known after apply)
                      + status  = (known after apply)
                    }

                  + replication_time {
                      + minutes = (known after apply)
                      + status  = (known after apply)
                    }
                }

              + filter {
                  + prefix = (known after apply)
                  + tags   = (known after apply)
                }

              + source_selection_criteria {
                  + sse_kms_encrypted_objects {
                      + enabled = (known after apply)
                    }
                }
            }
        }

      + server_side_encryption_configuration {
          + rule {
              + bucket_key_enabled = (known after apply)

              + apply_server_side_encryption_by_default {
                  + kms_master_key_id = (known after apply)
                  + sse_algorithm     = (known after apply)
                }
            }
        }

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }

      + website {
          + error_document           = (known after apply)
          + index_document           = (known after apply)
          + redirect_all_requests_to = (known after apply)
          + routing_rules            = (known after apply)
        }
    }

  # module.s3-bucket.aws_s3_bucket_versioning.name will be created
  + resource "aws_s3_bucket_versioning" "name" {
      + bucket = (known after apply)
      + id     = (known after apply)

      + versioning_configuration {
          + mfa_delete = (known after apply)
          + status     = "Enabled"
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.dynamo.aws_dynamodb_table.name: Creating...
module.s3-bucket.aws_s3_bucket.tf-state: Creating...
module.s3-bucket.aws_s3_bucket.tf-state: Creation complete after 5s [id=terraform-update-and-run-state]
module.s3-bucket.aws_s3_bucket_versioning.name: Creating...
module.s3-bucket.aws_s3_bucket_versioning.name: Creation complete after 2s [id=terraform-update-and-run-state]
module.dynamo.aws_dynamodb_table.name: Still creating... [10s elapsed]
module.dynamo.aws_dynamodb_table.name: Creation complete after 10s [id=terraform-update-and-run-state]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```
## now  s3 and dynamodb ready to create the backend in next demo
# [demo-02](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/tree/master/demo-02)
## Destroy everything

And the last step is to destroy all infrastructure


```
 terraform destroy
```
then back to [demo-01](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/tree/master/demo-0) to destroy the backend
