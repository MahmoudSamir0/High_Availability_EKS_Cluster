# demo-02
## overview


### Initialize the directory

When you create a new configuration — or check out an existing configuration
from version control — you need to initialize the directory with `terraform
init`. This step downloads the providers defined in the configuration.

Initialize the directory.

```shell script
terraform init
```
```
Initializing modules...

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/helm from the dependency lock file
- Using previously-installed hashicorp/aws v5.9.0
- Using previously-installed hashicorp/kubernetes v2.22.0
- Using previously-installed hashicorp/helm v2.10.1

Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

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

```shell script
terraform apply 
```
```
module.cluster_autoscaler.data.aws_iam_policy_document.kubernetes_cluster_autoscaler[0]: Reading...
module.cluster_autoscaler.data.aws_iam_policy_document.kubernetes_cluster_autoscaler[0]: Read complete after 0s [id=696514482]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # aws_acm_certificate.cert will be created
  + resource "aws_acm_certificate" "cert" {
      + arn                       = (known after apply)
      + domain_name               = "aspapp.com"
      + domain_validation_options = [
          + {
              + domain_name           = "aspapp.com"
              + resource_record_name  = (known after apply)
              + resource_record_type  = (known after apply)
              + resource_record_value = (known after apply)
            },
        ]
      + id                        = (known after apply)
      + key_algorithm             = (known after apply)
      + not_after                 = (known after apply)
      + not_before                = (known after apply)
      + pending_renewal           = (known after apply)
      + renewal_eligibility       = (known after apply)
      + renewal_summary           = (known after apply)
      + status                    = (known after apply)
      + subject_alternative_names = [
          + "aspapp.com",
        ]
      + tags_all                  = (known after apply)
      + type                      = (known after apply)
      + validation_emails         = (known after apply)
      + validation_method         = "DNS"

      + options {
          + certificate_transparency_logging_preference = (known after apply)
        }
    }

  # aws_iam_openid_connect_provider.default will be created
  + resource "aws_iam_openid_connect_provider" "default" {
      + arn             = (known after apply)
      + client_id_list  = [
          + "sts.amazonaws.com",
        ]
      + id              = (known after apply)
      + tags_all        = (known after apply)
      + thumbprint_list = (known after apply)
      + url             = (known after apply)
    }

  # aws_route53_record.www will be created
  + resource "aws_route53_record" "www" {
      + allow_overwrite = (known after apply)
      + fqdn            = (known after apply)
      + id              = (known after apply)
      + name            = "www.aspapp.com"
      + records         = (known after apply)
      + ttl             = 300
      + type            = "A"
      + zone_id         = (known after apply)
    }

  # aws_route53_zone.primary will be created
  + resource "aws_route53_zone" "primary" {
      + arn                 = (known after apply)
      + comment             = "Managed by Terraform"
      + force_destroy       = false
      + id                  = (known after apply)
      + name                = "aspapp.com"
      + name_servers        = (known after apply)
      + primary_name_server = (known after apply)
      + tags_all            = (known after apply)
      + zone_id             = (known after apply)
    }

  # helm_release.my-mongodb will be created
  + resource "helm_release" "my-mongodb" {
      + atomic                     = false
      + chart                      = "mongodb"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "my-mongodb"
      + namespace                  = "default"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://charts.bitnami.com/bitnami"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "13.16.0"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          + name  = "auth.rootPassword"
          + value = "12345mahmoud"
        }
      + set {
          + name  = "auth.rootUser"
          + value = "mahmoud"
        }
    }

  # helm_release.my-redis-cache will be created
  + resource "helm_release" "my-redis-cache" {
      + atomic                     = false
      + chart                      = "redis"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "my-redis-cache"
      + namespace                  = "default"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://charts.bitnami.com/bitnami"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "17.13.2"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          + name  = "auth.password"
          + value = "12345mahmoud"
        }
      + set {
          + name  = "cluster.enabled"
          + value = "true"
        }
      + set {
          + name  = "global.redis.password"
          + value = "12345mahmoud"
        }
      + set {
          + name  = "replica.autoscaling"
          + value = "true"
        }
    }

  # kubernetes_deployment.aspapp will be created
  + resource "kubernetes_deployment" "aspapp" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + labels           = {
              + "app" = "aspapp"
            }
          + name             = "aspapp"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "3"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "aspapp"
                }
            }

          + strategy {
              + type = (known after apply)

              + rolling_update {
                  + max_surge       = (known after apply)
                  + max_unavailable = (known after apply)
                }
            }

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app" = "aspapp"
                    }
                  + name             = (known after apply)
                  + resource_version = (known after apply)
                  + uid              = (known after apply)
                }

              + spec {
                  + automount_service_account_token  = true
                  + dns_policy                       = "ClusterFirst"
                  + enable_service_links             = true
                  + host_ipc                         = false
                  + host_network                     = false
                  + host_pid                         = false
                  + hostname                         = (known after apply)
                  + node_name                        = (known after apply)
                  + restart_policy                   = "Always"
                  + scheduler_name                   = (known after apply)
                  + service_account_name             = (known after apply)
                  + share_process_namespace          = false
                  + termination_grace_period_seconds = 30

                  + container {
                      + image                      = "2534m/aspnetapp:latest"
                      + image_pull_policy          = (known after apply)
                      + name                       = "aspapp"
                      + stdin                      = false
                      + stdin_once                 = false
                      + termination_message_path   = "/dev/termination-log"
                      + termination_message_policy = (known after apply)
                      + tty                        = false

                      + port {
                          + container_port = 80
                          + protocol       = "TCP"
                        }

                      + resources {
                          + limits   = (known after apply)
                          + requests = (known after apply)
                        }
                    }

                  + image_pull_secrets {
                      + name = (known after apply)
                    }

                  + readiness_gate {
                      + condition_type = (known after apply)
                    }
                }
            }
        }
    }

  # kubernetes_deployment.sqlserver will be created
  + resource "kubernetes_deployment" "sqlserver" {
      + id               = (known after apply)
      + wait_for_rollout = true

      + metadata {
          + generation       = (known after apply)
          + name             = "sqlserver"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + min_ready_seconds         = 0
          + paused                    = false
          + progress_deadline_seconds = 600
          + replicas                  = "1"
          + revision_history_limit    = 10

          + selector {
              + match_labels = {
                  + "app" = "sqlserver"
                }
            }

          + strategy {
              + type = (known after apply)

              + rolling_update {
                  + max_surge       = (known after apply)
                  + max_unavailable = (known after apply)
                }
            }

          + template {
              + metadata {
                  + generation       = (known after apply)
                  + labels           = {
                      + "app" = "sqlserver"
                    }
                  + name             = (known after apply)
                  + resource_version = (known after apply)
                  + uid              = (known after apply)
                }

              + spec {
                  + automount_service_account_token  = true
                  + dns_policy                       = "ClusterFirst"
                  + enable_service_links             = true
                  + host_ipc                         = false
                  + host_network                     = false
                  + host_pid                         = false
                  + hostname                         = (known after apply)
                  + node_name                        = (known after apply)
                  + restart_policy                   = "Always"
                  + scheduler_name                   = (known after apply)
                  + service_account_name             = (known after apply)
                  + share_process_namespace          = false
                  + termination_grace_period_seconds = 30

                  + container {
                      + image                      = "microsoft/mssql-server:2017-latest"
                      + image_pull_policy          = (known after apply)
                      + name                       = "sqlserver"
                      + stdin                      = false
                      + stdin_once                 = false
                      + termination_message_path   = "/dev/termination-log"
                      + termination_message_policy = (known after apply)
                      + tty                        = false

                      + env {
                          + name  = "ACCEPT_EULA"
                          + value = "Y"
                        }
                      + env {
                          + name  = "SA_PASSWORD"
                          + value = "12345mahmoud"
                        }

                      + port {
                          + container_port = 1433
                          + protocol       = "TCP"
                        }

                      + resources {
                          + limits   = (known after apply)
                          + requests = (known after apply)
                        }
                    }

                  + image_pull_secrets {
                      + name = (known after apply)
                    }

                  + readiness_gate {
                      + condition_type = (known after apply)
                    }
                }
            }
        }
    }

  # kubernetes_horizontal_pod_autoscaler.example will be created
  + resource "kubernetes_horizontal_pod_autoscaler" "example" {
      + id = (known after apply)

      + metadata {
          + generation       = (known after apply)
          + name             = "aspapp"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + max_replicas                      = 100
          + min_replicas                      = 3
          + target_cpu_utilization_percentage = (known after apply)

          + behavior {
              + scale_down {
                  + select_policy                = (known after apply)
                  + stabilization_window_seconds = (known after apply)

                  + policy {
                      + period_seconds = (known after apply)
                      + type           = (known after apply)
                      + value          = (known after apply)
                    }
                }

              + scale_up {
                  + select_policy                = (known after apply)
                  + stabilization_window_seconds = (known after apply)

                  + policy {
                      + period_seconds = (known after apply)
                      + type           = (known after apply)
                      + value          = (known after apply)
                    }
                }
            }

          + metric {
              + type = "External"

              + external {
                  + metric {
                      + name = "latency"

                      + selector {
                          + match_labels = (known after apply)
                        }
                    }

                  + target {
                      + type  = "Value"
                      + value = "100"
                    }
                }
            }

          + scale_target_ref {
              + kind = "Deployment"
              + name = "aspapp"
            }
        }
    }

  # kubernetes_service.aspapp_service will be created
  + resource "kubernetes_service" "aspapp_service" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = "aspapp"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + allocate_load_balancer_node_ports = true
          + cluster_ip                        = (known after apply)
          + cluster_ips                       = (known after apply)
          + external_traffic_policy           = (known after apply)
          + health_check_node_port            = (known after apply)
          + internal_traffic_policy           = (known after apply)
          + ip_families                       = (known after apply)
          + ip_family_policy                  = (known after apply)
          + publish_not_ready_addresses       = false
          + selector                          = {
              + "app" = "aspapp"
            }
          + session_affinity                  = "None"
          + type                              = "LoadBalancer"

          + port {
              + node_port   = (known after apply)
              + port        = 80
              + protocol    = "TCP"
              + target_port = "80"
            }

          + session_affinity_config {
              + client_ip {
                  + timeout_seconds = (known after apply)
                }
            }
        }
    }

  # kubernetes_service.sqlserver will be created
  + resource "kubernetes_service" "sqlserver" {
      + id                     = (known after apply)
      + status                 = (known after apply)
      + wait_for_load_balancer = true

      + metadata {
          + generation       = (known after apply)
          + name             = "sqlserver"
          + namespace        = "default"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }

      + spec {
          + allocate_load_balancer_node_ports = true
          + cluster_ip                        = (known after apply)
          + cluster_ips                       = (known after apply)
          + external_traffic_policy           = (known after apply)
          + health_check_node_port            = (known after apply)
          + internal_traffic_policy           = (known after apply)
          + ip_families                       = (known after apply)
          + ip_family_policy                  = (known after apply)
          + publish_not_ready_addresses       = false
          + selector                          = {
              + "app" = "sqlserver"
            }
          + session_affinity                  = "None"
          + type                              = "ClusterIP"

          + port {
              + node_port   = (known after apply)
              + port        = 1433
              + protocol    = "TCP"
              + target_port = "1433"
            }

          + session_affinity_config {
              + client_ip {
                  + timeout_seconds = (known after apply)
                }
            }
        }
    }

  # module.IAM.aws_iam_policy.ecr-cluster-access will be created
  + resource "aws_iam_policy" "ecr-cluster-access" {
      + arn         = (known after apply)
      + id          = (known after apply)
      + name        = "eks-ecr-access"
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ecr:GetAuthorizationToken",
                          + "ecr:BatchCheckLayerAvailability",
                          + "ecr:GetDownloadUrlForLayer",
                          + "ecr:GetRepositoryPolicy",
                          + "ecr:DescribeRepositories",
                          + "ecr:ListImages",
                          + "ecr:DescribeImages",
                          + "ecr:BatchGetImage",
                          + "ecr:GetLifecyclePolicy",
                          + "ecr:GetLifecyclePolicyPreview",
                          + "ecr:ListTagsForResource",
                          + "ecr:DescribeImageScanFindings",
                          + "ecr:InitiateLayerUpload",
                          + "ecr:UploadLayerPart",
                          + "ecr:CompleteLayerUpload",
                          + "ecr:PutImage",
                          + "ecr:DeleteRepository",
                          + "ecr:BatchDeleteImage",
                          + "ecr:SetRepositoryPolicy",
                          + "ecr:TagResource",
                          + "ecr:UntagResource",
                          + "ecr:GetRegistryPolicy",
                          + "ecr:PutRegistryPolicy",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.IAM.aws_iam_role.eks-iam-role will be created
  + resource "aws_iam_role" "eks-iam-role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "eks.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "Fixeds-eks-iam-role"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.IAM.aws_iam_role.workernodes will be created
  + resource "aws_iam_role" "workernodes" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + Service = "ec2.amazonaws.com"
                        }
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = "eks-node-group-example"
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.IAM.aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      + role       = "eks-node-group-example"
    }

  # module.IAM.aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly-EKS will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      + role       = "Fixeds-eks-iam-role"
    }

  # module.IAM.aws_iam_role_policy_attachment.AmazonEKSClusterPolicy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
      + role       = "Fixeds-eks-iam-role"
    }

  # module.IAM.aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
      + role       = "eks-node-group-example"
    }

  # module.IAM.aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy will be created
  + resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      + role       = "eks-node-group-example"
    }

  # module.IAM.aws_iam_role_policy_attachment.EC2InstanceProfileForImageBuilderECRContainerBuilds will be created
  + resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
      + role       = "eks-node-group-example"
    }

  # module.IAM.aws_iam_role_policy_attachment.ecr-cluster-access will be created
  + resource "aws_iam_role_policy_attachment" "ecr-cluster-access" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = "Fixeds-eks-iam-role"
    }

  # module.cluster_autoscaler.data.aws_iam_policy_document.kubernetes_cluster_autoscaler_assume[0] will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "kubernetes_cluster_autoscaler_assume" {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions = [
              + "sts:AssumeRoleWithWebIdentity",
            ]
          + effect  = "Allow"

          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "system:serviceaccount:kube-system:cluster-autoscaler",
                ]
              + variable = (known after apply)
            }

          + principals {
              + identifiers = [
                  + (known after apply),
                ]
              + type        = "Federated"
            }
        }
    }

  # module.cluster_autoscaler.aws_iam_policy.kubernetes_cluster_autoscaler[0] will be created
  + resource "aws_iam_policy" "kubernetes_cluster_autoscaler" {
      + arn         = (known after apply)
      + description = "Policy for cluster autoscaler service"
      + id          = (known after apply)
      + name        = (known after apply)
      + name_prefix = (known after apply)
      + path        = "/"
      + policy      = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:DescribeLaunchTemplateVersions",
                          + "ec2:DescribeInstanceTypes",
                          + "autoscaling:TerminateInstanceInAutoScalingGroup",
                          + "autoscaling:SetDesiredCapacity",
                          + "autoscaling:DescribeTags",
                          + "autoscaling:DescribeLaunchConfigurations",
                          + "autoscaling:DescribeAutoScalingInstances",
                          + "autoscaling:DescribeAutoScalingGroups",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + policy_id   = (known after apply)
      + tags_all    = (known after apply)
    }

  # module.cluster_autoscaler.aws_iam_role.kubernetes_cluster_autoscaler[0] will be created
  + resource "aws_iam_role" "kubernetes_cluster_autoscaler" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + managed_policy_arns   = (known after apply)
      + max_session_duration  = 3600
      + name                  = (known after apply)
      + name_prefix           = (known after apply)
      + path                  = "/"
      + tags_all              = (known after apply)
      + unique_id             = (known after apply)

      + inline_policy {
          + name   = (known after apply)
          + policy = (known after apply)
        }
    }

  # module.cluster_autoscaler.aws_iam_role_policy_attachment.kubernetes_cluster_autoscaler[0] will be created
  + resource "aws_iam_role_policy_attachment" "kubernetes_cluster_autoscaler" {
      + id         = (known after apply)
      + policy_arn = (known after apply)
      + role       = (known after apply)
    }

  # module.cluster_autoscaler.helm_release.cluster_autoscaler[0] will be created
  + resource "helm_release" "cluster_autoscaler" {
      + atomic                     = false
      + chart                      = "cluster-autoscaler"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "cluster-autoscaler"
      + namespace                  = "kube-system"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://kubernetes.github.io/autoscaler"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + values                     = [
          + jsonencode({}),
        ]
      + verify                     = false
      + version                    = "9.9.2"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          + name  = "autoDiscovery.clusterName"
          + value = (known after apply)
        }
      + set {
          + name  = "awsRegion"
          + value = "us-east-1"
        }
      + set {
          + name  = "fullnameOverride"
          + value = "aws-cluster-autoscaler"
        }
      + set {
          + name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
          + value = (known after apply)
        }
      + set {
          + name  = "rbac.serviceAccount.name"
          + value = "cluster-autoscaler"
        }
    }

  # module.ekscluster.aws_eks_cluster.ekscluster will be created
  + resource "aws_eks_cluster" "ekscluster" {
      + arn                   = (known after apply)
      + certificate_authority = (known after apply)
      + cluster_id            = (known after apply)
      + created_at            = (known after apply)
      + endpoint              = (known after apply)
      + id                    = (known after apply)
      + identity              = (known after apply)
      + name                  = "new_eks"
      + platform_version      = (known after apply)
      + role_arn              = (known after apply)
      + status                = (known after apply)
      + tags_all              = (known after apply)
      + version               = (known after apply)

      + kubernetes_network_config {
          + ip_family         = (known after apply)
          + service_ipv4_cidr = (known after apply)
          + service_ipv6_cidr = (known after apply)
        }

      + vpc_config {
          + cluster_security_group_id = (known after apply)
          + endpoint_private_access   = true
          + endpoint_public_access    = false
          + public_access_cidrs       = (known after apply)
          + security_group_ids        = (known after apply)
          + subnet_ids                = (known after apply)
          + vpc_id                    = (known after apply)
        }
    }

  # module.ekscluster.aws_eks_node_group.worker-node-group will be created
  + resource "aws_eks_node_group" "worker-node-group" {
      + ami_type               = (known after apply)
      + arn                    = (known after apply)
      + capacity_type          = (known after apply)
      + cluster_name           = "new_eks"
      + disk_size              = (known after apply)
      + id                     = (known after apply)
      + instance_types         = [
          + "t2.medium",
        ]
      + node_group_name        = "new_node_group"
      + node_group_name_prefix = (known after apply)
      + node_role_arn          = (known after apply)
      + release_version        = (known after apply)
      + resources              = (known after apply)
      + status                 = (known after apply)
      + subnet_ids             = (known after apply)
      + tags_all               = (known after apply)
      + version                = (known after apply)

      + scaling_config {
          + desired_size = 1
          + max_size     = 1
          + min_size     = 1
        }

      + update_config {
          + max_unavailable            = (known after apply)
          + max_unavailable_percentage = (known after apply)
        }
    }

  # module.network.aws_eip.elastic_id will be created
  + resource "aws_eip" "elastic_id" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + carrier_ip           = (known after apply)
      + customer_owned_ip    = (known after apply)
      + domain               = (known after apply)
      + id                   = (known after apply)
      + instance             = (known after apply)
      + network_border_group = (known after apply)
      + network_interface    = (known after apply)
      + private_dns          = (known after apply)
      + private_ip           = (known after apply)
      + public_dns           = (known after apply)
      + public_ip            = (known after apply)
      + public_ipv4_pool     = (known after apply)
      + tags                 = {
          + "Name" = "master_eip"
        }
      + tags_all             = {
          + "Name" = "master_eip"
        }
      + vpc                  = true
    }

  # module.network.aws_internet_gateway.it will be created
  + resource "aws_internet_gateway" "it" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "internet-getway"
        }
      + tags_all = {
          + "Name" = "internet-getway"
        }
      + vpc_id   = (known after apply)
    }

  # module.network.aws_nat_gateway.gw will be created
  + resource "aws_nat_gateway" "gw" {
      + allocation_id        = (known after apply)
      + association_id       = (known after apply)
      + connectivity_type    = "public"
      + id                   = (known after apply)
      + network_interface_id = (known after apply)
      + private_ip           = (known after apply)
      + public_ip            = (known after apply)
      + subnet_id            = (known after apply)
      + tags                 = {
          + "name" = "nat-ec1"
        }
      + tags_all             = {
          + "name" = "nat-ec1"
        }
    }

  # module.network.aws_route_table.myroute will be created
  + resource "aws_route_table" "myroute" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "Public Route Table"
        }
      + tags_all         = {
          + "Name" = "Public Route Table"
        }
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table.privett will be created
  + resource "aws_route_table" "privett" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = (known after apply)
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags             = {
          + "Name" = "myprivate_nat-1"
        }
      + tags_all         = {
          + "Name" = "myprivate_nat-1"
        }
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table_association.myrout-a will be created
  + resource "aws_route_table_association" "myrout-a" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.myrout-b will be created
  + resource "aws_route_table_association" "myrout-b" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.privett-a will be created
  + resource "aws_route_table_association" "privett-a" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_subnet.mysub_az1[0] will be created
  + resource "aws_subnet" "mysub_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.0.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_az1"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_az1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.mysub_az1[1] will be created
  + resource "aws_subnet" "mysub_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_az1"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_az1"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.mysub_az2[0] will be created
  + resource "aws_subnet" "mysub_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "public_subnet_az2"
        }
      + tags_all                                       = {
          + "Name" = "public_subnet_az2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.mysub_az2[1] will be created
  + resource "aws_subnet" "mysub_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1b"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "private_subnet_az2"
        }
      + tags_all                                       = {
          + "Name" = "private_subnet_az2"
        }
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_vpc.myvpc will be created
  + resource "aws_vpc" "myvpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

  # module.security.aws_security_group.eks_cluster will be created
  + resource "aws_security_group" "eks_cluster" {
      + arn                    = (known after apply)
      + description            = "Security group for EKS cluster"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 443
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 443
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = "eks_cluster_"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

Plan: 41 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 


```

# congratulations your app is ready 
## now now open app url (https://www.aspapp.com)
![app](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/blob/master/Screenshot%20from%202023-07-23%2023-15-22.png)
## Destroy everything

And the last step is to destroy all infrastructure


```
 terraform destroy
```
then back to [demo-01](https://github.com/MahmoudSamir0/High_Availability_EKS_Cluster/tree/master/demo-0) to destroy the backend

# Notes:
Be careful of Rout53 domain = 12$ for 12 month for domain
 
