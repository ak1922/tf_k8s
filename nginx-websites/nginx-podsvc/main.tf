# Create namespace
resource "kubernetes_namespace" "work_space" {
  metadata {
    name = "eks-devops"

    annotations = {
      projects = "eksdevops"
    }

    labels = {
      language = "terraform"
    }
  }
}

# Create pod for Nginx
resource "kubernetes_pod" "web_pod" {
  metadata {
    namespace = "eks-devops"
    name      = "eksdps-nginxpod"

    labels = {
      app = "nginx"
    }
  }

  spec {
    container {
      image = "nginx:latest"
      name  = "eksdps-nginx"
    }
  }
}

resource "kubernetes_service" "web_pod_svc" {
  metadata {
    name      = "eksdps-nginxpod-service"
    namespace = "eks-devops"
  }

  spec {
    selector = {
      app = kubernetes_pod.web_pod.metadata[0].labels.app
    }

    port {
      node_port   = 30501
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
