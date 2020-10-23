provider "google" {
  credentials = file("/home/serhii/Documents/configs/gcp/anomaly-detection-presentation-terraform-operator.json")
  project = var.project_id
  region  = var.region
}

locals {
  incoming_topic_name = "incoming-topic",
  incoming_topic_subscription = "incoming-topic-sub"

}

resource "google_project_service" "apis" {
  for_each = toset([
    "dataflow.googleapis.com",
    "pubsub.googleapis.com",
    "dlp.googleapis.com",
    "cloudbuild.googleapis.com",
    "storage-component.googleapis.com"
  ])
  service = each.value
}

resource "google_pubsub_topic" "incoming_topic" {
  name = local.incoming_topic_name
}

resource "google_pubsub_subscription" "incoming_subscription" {
  name  = local.incoming_topic_subscription
  topic = google_pubsub_topic.incoming_topic.name
}

resource "google_project_iam_binding" "dataflow_admin" {
    role    = "roles/dataflow.admin"
    members = [
        join("", ["serviceAccount:",var.project_number, "@cloudbuild.gserviceaccount.com"])
    ]
}
