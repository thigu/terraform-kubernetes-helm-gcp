resource "google_compute_global_address" "thiagocloud_static_ip" {
  name = "thiagocloud-static-ip"
}

resource "google_compute_global_address" "thiagocloud_monitor_static_ip" {
  name = "thiagocloud-monitor-static-ip"
} 

