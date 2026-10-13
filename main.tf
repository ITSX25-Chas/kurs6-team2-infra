terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

locals {
  instructor_vpc_self_link = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/instructor-vpc"
  team_zone                = (var.team_id - 1) % 3
  jumphost_zone            = coalesce(var.jumphost_zone, data.google_compute_zones.available.names[local.team_zone])
  primary_zone             = coalesce(var.primary_zone, data.google_compute_zones.available.names[local.team_zone])
  subnet_cidr              = "10.0.${var.team_id}.0/24"
}

data "google_compute_zones" "available" {
  region = var.region
}

data "google_compute_network" "team_vpc" {
  name = "team${var.team_id}-vpc"
}

resource "google_compute_subnetwork" "team" {
  name          = "team${var.team_id}-subnet"
  ip_cidr_range = local.subnet_cidr
  region        = var.region
  network       = data.google_compute_network.team_vpc.id
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "team2-allow-iap-ssh"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["jumphost", "primary"] # Lägger till båda för säkerhets skull
}

resource "google_compute_firewall" "allow_k3s" {
  name    = "allow-team2-k3s"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["10.0.2.0/24"]
  target_tags   = ["primary"]
}

resource "google_compute_address" "jumphost" {
  name   = "team${var.team_id}-jumphost-ip"
  region = var.region
}

resource "google_compute_route" "internet_via_jumphost" {
  name              = "team${var.team_id}-internet-via-jumphost"
  network           = data.google_compute_network.team_vpc.id
  dest_range        = "0.0.0.0/0"
  priority          = 800
  next_hop_instance = google_compute_instance.jumphost.self_link
  tags              = ["no-external-ip"]
}

resource "google_compute_route" "tailnet_via_jumphost" {
  name              = "team${var.team_id}-tailnet-via-jumphost"
  network           = data.google_compute_network.team_vpc.id
  dest_range        = "100.64.0.0/10"
  priority          = 800
  next_hop_instance = google_compute_instance.jumphost.self_link
  tags              = ["no-external-ip"]
}

resource "google_compute_resource_policy" "daily_schedule" {
  name   = "team${var.team_id}-daily-schedule"
  region = var.region

  instance_schedule_policy {
    time_zone = "Europe/Stockholm"
    vm_start_schedule {
      schedule = "0 8 * * *"
    }
    vm_stop_schedule {
      schedule = "0 0 * * *"
    }
  }
}
resource "google_compute_instance_iam_member" "jumphost_os_login" {
  for_each      = toset(var.os_admin_users)
  instance_name = google_compute_instance.jumphost.name
  zone          = google_compute_instance.jumphost.zone
  role          = "roles/compute.osAdminLogin"
  member        = "user:${each.value}"
}

resource "google_compute_instance_iam_member" "primary_os_login" {
  for_each      = toset(var.os_admin_users)
  instance_name = google_compute_instance.primary.name
  zone          = google_compute_instance.primary.zone
  role          = "roles/compute.osAdminLogin"
  member        = "user:${each.value}"
}

resource "google_compute_instance" "jumphost" {
  name         = "team${var.team_id}-jumphost"
  machine_type = "e2-micro"
  zone         = local.jumphost_zone

  allow_stopping_for_update = true
  can_ip_forward            = true

  tags = ["jumphost"]

  resource_policies = [google_compute_resource_policy.daily_schedule.id]

  boot_disk {
    initialize_params {
      image = "${var.project_id}/debian"
      size  = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.team.id
    network_ip = cidrhost(local.subnet_cidr, 2)
    access_config {
      nat_ip = google_compute_address.jumphost.address
    }
  }
  service_account {
    email  = "team${var.team_id}-jumphost@${var.project_id}.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = true
    startup-script         = <<-EOT
      #!/bin/bash
      set -e

      if ! swapon --show | grep -q "/swapfile"; then
        fallocate -l 1G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
      fi

      echo 'vm.swappiness=20' > /etc/sysctl.d/01-swappiness.conf
      echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/99-ip-forward.conf
      sysctl --system

      DEFAULT_IF=$(ip ro sh default | awk '/default/ {print $5}')
      iptables -t nat -C POSTROUTING -o "$DEFAULT_IF" -s "${local.subnet_cidr}" -j MASQUERADE 2>/dev/null || \
        iptables -t nat -A POSTROUTING -o "$DEFAULT_IF" -s "${local.subnet_cidr}" -j MASQUERADE
      iptables -t nat -C POSTROUTING -o "$DEFAULT_IF" -d 10.0.0.2/32 -j MASQUERADE 2>/dev/null || \
        iptables -t nat -A POSTROUTING -o "$DEFAULT_IF" -d 10.0.0.2/32 -j MASQUERADE
    EOT
  }
}

resource "google_compute_instance" "primary" {
  name         = "team${var.team_id}-primary"
  machine_type = "e2-small"
  zone         = local.primary_zone

  allow_stopping_for_update = true

  tags = ["primary", "no-external-ip"]

  resource_policies = [google_compute_resource_policy.daily_schedule.id]

  boot_disk {
    initialize_params {
      image = "${var.project_id}/debian"
      size  = 20
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.team.id
    network_ip = cidrhost(local.subnet_cidr, 3)
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = true
    startup-script         = <<-EOT
      #!/bin/bash
      set -e

      if ! swapon --show | grep -q "/swapfile"; then
        fallocate -l 1G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
      fi

      echo 'vm.swappiness=20' > /etc/sysctl.d/01-swappiness.conf
      sysctl --system
    EOT
  }
}

# SECURITY FIX (PB-05): Replaced overly permissive allow-all firewall rule
# with two specific rules following the principle of least privilege.
#
# Original issue: Single rule allowed ALL protocols from 0.0.0.0/0 (entire
# internet) to both jumphost and primary machines, exposing every port to
# the entire internet.
#
# Fix:
# 1. allow_ssh - Only TCP port 22 from the instructor network, jumphost only.
# 2. allow_internal - All protocols within team subnet only (10.0.2.0/24).

resource "google_compute_firewall" "allow_ssh" {
  name    = "team${var.team_id}-allow-ssh"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["10.0.0.0/24"]
  target_tags   = ["jumphost"]
}

resource "google_compute_firewall" "allow_internal" {
  name    = "team${var.team_id}-allow-internal"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.2.0/24"]
  target_tags   = ["jumphost", "primary"]
}

# When subnet-router SNAT is disabled, primary sees the authenticated client's
# Tailnet address instead of the jumphost's VPC address. Limit that traffic to
# the protocols needed for connectivity checks, administration and this lab.
resource "google_compute_firewall" "allow_tailnet_to_primary" {
  name    = "team${var.team_id}-allow-tailnet-to-primary"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "8000"]
  }

  source_ranges = ["100.64.0.0/10"]
  target_tags   = ["primary"]
}

# Headscale clients connect to the team domain through the instructor's reverse
# proxy. Restricting the source to 10.0.0.2/32 lets that proxy reach port 8080
# without exposing the Headscale backend directly to the internet, as the
# previous 0.0.0.0/0 source range did.
resource "google_compute_firewall" "allow_headscale" {
  name    = "team${var.team_id}-allow-headscale"
  network = data.google_compute_network.team_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["10.0.0.2/32"]
  target_tags   = ["jumphost"]
}
