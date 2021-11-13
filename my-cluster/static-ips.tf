resource "google_compute_global_address" "thiagocloud_static_ip" {
  name = "thiagocloud-static-ip"
}

resource "google_compute_address" "gitlab_static_ip" {
  name = "gitlab-static-ip"
}
