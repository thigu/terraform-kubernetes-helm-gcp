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

resource "google_dns_record_set" "cname_thiagocloud" {
  name = "www.${google_dns_managed_zone.primary.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.primary.name}"

  rrdatas = ["${google_dns_managed_zone.primary.dns_name}"]
}

resource "google_dns_record_set" "gitlab" {
  # wild card domain name for gitlab services
  name = "*.ci.${google_dns_managed_zone.primary.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.primary.name}"

  rrdatas = ["${google_compute_address.gitlab_static_ip.address}"]
}
