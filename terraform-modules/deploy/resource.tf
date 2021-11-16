resource "time_sleep" "wait_30_seconds" {
  depends_on = [helm_release.myapp]

  create_duration = "30s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

resource "kubernetes_ingress" "ingress-app" {
  depends_on = [null_resource.next]
  metadata {
    labels = {
      app      = "ingress-${var.appname}"
    }
    name = "ingress-${var.appname}"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = "thiagocloud-static-ip"
    }
  }

  spec {

    backend {
      service_name = "${var.appname}"
      service_port = 8080
             
    }
  
    rule {
      http {
        path {
          path = "/"
	  backend {
            service_name = "${var.appname}"
            service_port = 8080
          }   
        }
	path {
	  path = "/controllers.js"
	  backend {
            service_name = "${var.appname}"
            service_port = 8080
          }
   	}
      }
    }
  }

}

resource "helm_release" "my-kubernetes-dashboard" {

  name = "my-kubernetes-dashboard"

  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  namespace  = "default"

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "NodePort"
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

resource "kubernetes_ingress" "ingress-monitor" {
  depends_on = [helm_release.my-kubernetes-dashboard]
  metadata { 
    labels = { 
      app      = "ingress-dashboard"
    }
    name = "ingress-dashboard"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = "thiagocloud-monitor-static-ip"
    }
  }

  spec {
    
    backend {
      service_name = "my-kubernetes-dashboard"
      service_port = 443
     
    }
    
    rule { 
      http { 
        path { 
          path = "/*"
          backend {
            service_name = "my-kubernetes-dashboard"
            service_port = 443
          }
        }
      }
    }
  }

}
