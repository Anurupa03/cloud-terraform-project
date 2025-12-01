resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.name
    labels = {
      environment = var.environment
      managed-by  = "terraform"
    }
  }
}