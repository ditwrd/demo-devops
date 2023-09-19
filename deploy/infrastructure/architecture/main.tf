terraform {
  backend "gcs" {
    bucket      = "demo-devops-tf-state-bucket"
    credentials = "serviceAccount.json"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.83.0"
    }
  }
}


provider "google" {
  credentials = "serviceAccount.json"
  project     = var.gcp_project_id["default"]
  region      = var.region
  zone        = var.zone
}

# Data

data "google_compute_image" "server_image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"

}

# Resources
resource "google_compute_network" "vpc_network" {
  name = "${var.project_name}-network"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "${var.project_name}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "ingress_firewall" {
  name    = "${var.project_name}-ingress-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  source_ranges = ["0.0.0.0/0"]

}

resource "google_compute_firewall" "egress_firewall" {
  name    = "${var.project_name}-egress-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
  }

  source_ranges = ["10.0.1.0/24"]
  direction     = "EGRESS"

}

resource "google_compute_instance" "main_server" {
  name         = "${var.project_name}-server-${terraform.workspace}"
  machine_type = "e2-micro"
  zone         = var.zone

  network_interface {
    subnetwork = google_compute_subnetwork.vpc_subnetwork.id

    access_config {

    }
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.server_image.self_link
    }
  }

  metadata = {
    ssh-keys = "aditya_wardianto11:${file("~/.ssh/demo.pub")}"
  }

}
