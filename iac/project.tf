provider "google" {
  credentials = file("/home/serhii/Documents/configs/gcp/anomaly-detection-presentation-terraform-operator.json")
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "dataflow_service" {
  project = var.project_id
  service = "dataflow.googleapis.com"
}

resource "google_project_service" "dlp_service" {
  project = var.project_id
  service = "dlp.googleapis.com"
}

resource "google_project_service" "pubsub_service" {
  project = var.project_id
  service = "pubsub.googleapis.com"
}

resource "google_project_service" "cloudbuild_service" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "storage_component_service" {
  project = var.project_id
  service = "storage-component.googleapis.com"
}