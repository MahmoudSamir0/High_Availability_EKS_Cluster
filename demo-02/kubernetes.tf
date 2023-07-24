provider "kubernetes" {
  host                   = module.ekscluster.eksEndpoint
  cluster_ca_certificate = base64decode(module.ekscluster.certificate_authority)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.ekscluster.eksname]
    command     = "aws"
  }
}

# Create Kubernetes deployment and service for asp app
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
  depends_on = [module.ekscluster]
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
  depends_on = [kubernetes_deployment.aspapp]
}
# Create Kubernetes autoscaler
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
  depends_on = [module.ekscluster]
}

# Kubernetes deployment and service for SQL Server
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
            name  = "ACCEPT_EULA"
            value = "Y"
          }

          env {
            name  = "SA_PASSWORD"
            value = "12345mahmoud"
          }
        }
      }
    }
  }
  depends_on = [module.ekscluster]

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
  depends_on = [module.ekscluster]
}


