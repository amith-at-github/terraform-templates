resource "kubernetes_namespace" "confluent" {
  metadata {
    name = "confluent"
  }

  depends_on = [
    module.eks
  ]

  #   provider = kubernetes.r1
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }

  depends_on = [
    module.eks
  ]

  #   provider = kubernetes.r1
}

resource "helm_release" "cfk" {
  name = "confluent-for-kubernetes"

  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"

  namespace = "confluent"

  set {
    name  = "namespaced"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.confluent,
  ]

  #   provider = helm.r1
}


resource "helm_release" "prometheus-community" {
  name = "demo-test"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  namespace = "monitoring"

  set {
    name  = "namespaced"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.monitoring,
  ]

  #   provider = helm.r1
}

resource "helm_release" "grafana" {
  name = "grafana"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"

  namespace = "monitoring"

  set {
    name  = "namespaced"
    value = "false"
  }
  #   values = [
  #     templatefile("${path.module}/templates/grafana-values.yaml", {
  #       admin_existing_secret = kubernetes_secret.grafana.metadata[0].name
  #       admin_user_key        = "admin-user"
  #       admin_password_key    = "admin-password"
  #       prometheus_svc        = "${helm_release.prometheus.name}-server"
  #       replicas              = 1
  #     })
  #   ]

  depends_on = [
    kubernetes_namespace.monitoring,
  ]

  #   provider = helm.r1
}
# resource "kubernetes_secret" "grafana" {
#   metadata {
#     name      = "grafana"
#     namespace = "monitoring"
#   }

#   data = {
#     admin-user     = "admin"
#     admin-password = random_password.grafana.result
#   }
# }

# resource "random_password" "grafana" {
#   length = 24
# }