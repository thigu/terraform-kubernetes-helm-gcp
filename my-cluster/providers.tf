provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
  credentials = file(var.credentials_file)
  zone = "${var.zone}"
}

provider "helm" {
  kubernetes {
    config_path = "${var.kubeconfig}"
  }
}
