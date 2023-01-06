provider "google" {
  project     = "idfy-299017"
  region      = "asia-south1"
}

data "google_compute_image" "instance_image" {
  name    = var.image_name
  project = var.image_project_id
}

data "google_service_account" "service_account" {
  project    = var.project_id
  account_id = var.service_account_id

}
// A single Google Cloud Engine instance
resource "google_compute_instance" "zookeeper" {
  count        = var.zookeeper_instance_count
  name         = "${var.zookeeper_name}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.cluster_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.instance_image.self_link
    }
  }


  metadata_startup_script = file("${path.module}/startup_script.sh")
  metadata = {
    MAX = var.zookeeper_instance_count
    SERVER_NAME=var.zookeeper_name
  }

  network_interface {
    network = "default"
    #network    = "projects/${var.network_project_id}/global/networks/${var.network_name}"
    #subnetwork = "projects/${var.network_project_id}/regions/${var.cluster_region}/subnetworks/${var.subnet_name}"
    access_config {
      #nat_ip = data.google_compute_address.vm_ip_address.address
    }
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
  service_account {
    email = data.google_service_account.service_account.email
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute"
    ]
  }

  tags       = [var.zookeeper_name, "ssh", "clickhouse", "zookeeper", "all"]
  depends_on = [data.google_service_account.service_account]
}

