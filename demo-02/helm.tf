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


