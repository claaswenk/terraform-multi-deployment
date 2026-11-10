provider "google" {
  project = var.project
  region  = var.location
}
# Workflow-Trigger Test
resource "google_compute_network" "application" {
  name                    = "application-network"
  auto_create_subnetworks = true
}

resource "google_compute_instance" "application" {
  count = var.replicas

  name         = "application-${count.index + 1}"
  machine_type = "e2-micro"
  zone         = "${var.location}-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.application.name

    dynamic "access_config" {
      for_each = var.enableExternalIP ? [google_compute_address.external[count.index].address] : []

      content {
        nat_ip = access_config.value
      }
    }
  }
}

resource "google_compute_address" "external" {
  count  = var.enableExternalIP ? var.replicas : 0
  name   = "application-external-ip-${count.index + 1}"
  region = var.location
}
