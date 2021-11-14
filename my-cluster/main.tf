# create network to run cluster instances
module "vpc_network" {
  source = "../terraform-modules/vpc"
  name   = "${var.ntw_name}"
}

# create Kubernetes cluster
module "kubernetes_cluster" {
  source             = "../terraform-modules/cluster"
  name               = "${var.name}"
  description        = "${var.description}"
  zone               = "${var.zone}"
  initial_node_count = "${var.initial_node_count}"
  network            = "${module.vpc_network.name}"
  project_id	     = "${var.project_id}"
}

# deploy application
module "app_deploy" {
  source 	    = "../terraform-modules/deploy"
  appname	    = "${var.appname}"
  repository        = "${var.repository}"
  chart  	    = "${var.chart}"
  depends_on	    = [module.kubernetes_cluster,module.vpc_network]
  static_ip         = "${google_compute_global_address.thiagocloud_static_ip.address}"
  monitor_static_ip = "${google_compute_global_address.thiagocloud_monitor_static_ip.address}"
}
