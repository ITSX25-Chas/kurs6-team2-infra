resource "google_compute_firewall" "allow_internal_to_jumphost" {
  name    = "team2-allow-internal-to-jumphost"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.2.0/24"]
  target_tags   = ["jumphost"]
}
