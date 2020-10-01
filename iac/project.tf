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

resource "google_pubsub_topic" "incoming_topic" {
  name = var.topic_id
}

resource "google_pubsub_subscription" "incoming_subscription" {
  name  = var.subscription_id
  topic = google_pubsub_topic.incoming_topic.name
}

resource "google_project_iam_binding" "dataflow_admin" {
    role    = "roles/dataflow.admin"
    members = [
        join("", ["serviceAccount:",var.project_number, "@cloudbuild.gserviceaccount.com"])
    ]
}
