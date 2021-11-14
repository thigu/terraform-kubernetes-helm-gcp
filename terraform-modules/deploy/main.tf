resource "helm_release" "myapp" {

  name = "${var.appname}"

  repository = "${var.repository}"
  chart      = "${var.chart}"
  namespace  = "default"
 
  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.port"
    value = "8080"
  }


  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "rbac.clusterReadOnlyRole"
    value = "true"
  }
}

