resource "google_dns_managed_zone" "primary" {
  name        = "thiagocloud-zone"
  dns_name    = "cloud.thiagofmleite.com."
  description = "DNS zone for the Thiago Cloud"
}

resource "google_dns_record_set" "a_thiagocloud" {
  name = "${google_dns_managed_zone.primary.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.primary.name}"

  rrdatas = ["${google_compute_global_address.thiagocloud_static_ip.address}"]
}

resource "google_dns_record_set" "a_monitor_thiagocloud" {
  name = "monitor.${google_dns_managed_zone.primary.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.primary.name}"

  rrdatas = ["${google_compute_global_address.thiagocloud_monitor_static_ip.address}"]
}

