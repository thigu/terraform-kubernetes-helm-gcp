resource "time_sleep" "wait_30_seconds" {
  depends_on = [helm_release.myapp]

  create_duration = "30s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

resource "kubernetes_ingress" "ingress" {
  depends_on = [null_resource.next]
  metadata {
    labels = {
      app      = "ingress-nginx"
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
