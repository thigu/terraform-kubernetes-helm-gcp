resource "kubernetes_ingress" "ingress" {
  depends_on = [helm_release.myapp]
  metadata {
    labels = {
      app      = "ingress-nginx"
    }
    name = "ingress-${var.appname}"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name": "thiagocloud_static_ip"
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
