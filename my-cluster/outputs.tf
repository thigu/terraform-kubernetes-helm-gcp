output "thiagocloud_static_ip" {
  value = "${google_compute_global_address.thiagocloud_static_ip.address}"
}

output "thiagocloud_monitor_static_ip" {
  value = "${google_compute_global_address.thiagocloud_monitor_static_ip.address}"
}

output "access-app" {
  value = " ... \nOpen your browser and type cloud.thiagofmleite.com to access the application."
}
