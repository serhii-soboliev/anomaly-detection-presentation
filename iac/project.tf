locals {
  bucket_name = "anomaly-detection-presentation-data"
  new_file_to_storage_topic_name="new-file-to-storage"
  incoming_topic_name = "incoming-topic"
  bq_dataset_name = "work_ds"
  cluster_model_data_table_name = "cluster_model_data"
}

provider "google" {
  project = var.project_id
  region = var.region
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
  project = var.project_id
}

resource "google_pubsub_topic" "new_file_to_storage_topic" {
  name = local.new_file_to_storage_topic_name
  project = var.project_id
}

resource "google_project_iam_binding" "dataflow_admin" {
  role = "roles/dataflow.admin"
  members = [
    join("", [
      "serviceAccount:",
      var.project_number,
      "@cloudbuild.gserviceaccount.com"])
  ]
}

resource "google_storage_bucket" "batch_data" {
  name = local.bucket_name
  location = var.region
}


resource "google_storage_notification" "new_file_to_bucket_notification" {
  bucket         = google_storage_bucket.batch_data.name
  object_name_prefix = "incoming"
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.new_file_to_storage_topic.id
  event_types    = ["OBJECT_FINALIZE"]
  depends_on = [google_pubsub_topic_iam_binding.storage_notification_binding]
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic_iam_binding" "storage_notification_binding" {
  topic   = google_pubsub_topic.new_file_to_storage_topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

resource "google_storage_bucket_object" "dynamic_template_secure_log_aggr_template_object" {
  name = "dynamic_template_secure_log_aggr_template.json"
  bucket = google_storage_bucket.batch_data.name
  source = "init_data/dynamic_template_secure_log_aggr_template.json"
}

resource "google_storage_bucket_object" "normalized_centroid_data_object" {
  name = "normalized_centroid_data.json"
  bucket = google_storage_bucket.batch_data.name
  source = "init_data/normalized_centroid_data.json"
}

resource "google_storage_bucket_object" "normalized_cluster_data_sql_object" {
  name = "normalized_cluster_data.sql"
  bucket = google_storage_bucket.batch_data.name
  source = "init_data/normalized_cluster_data.sql"
}

resource "google_storage_bucket_object" "synthetic_data_generator_template_object" {
  name = "dataflow_templates/synthetic_data_generator.json"
  bucket = google_storage_bucket.batch_data.name
  source = "init_data/synthetic_data_generator.json"
}

resource "google_storage_bucket_object" "synthetic_data_schema_object" {
  name = "schemas/synthetic_data_schema.json"
  bucket = google_storage_bucket.batch_data.name
  source = "init_data/synthetic_data_schema.json"
}

resource "google_bigquery_dataset" "anomaly_detection_presentation_ds" {
  dataset_id = local.bq_dataset_name
  friendly_name = "adp-ds"
  description = "Anomaly Detection Presentation Dataset"
  location = "EU"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigquery_table" "audience_events_data" {
  dataset_id = google_bigquery_dataset.anomaly_detection_presentation_ds.dataset_id
  table_id = "audience_events_data"
  description = "Audience Events Table"
  schema = file("bqtables/audience_events_data_schema.json")
}

resource "google_bigquery_table" "outlier_data" {
  dataset_id = google_bigquery_dataset.anomaly_detection_presentation_ds.dataset_id
  table_id = "outlier_data"
  description = "Network Log Outlier Table"
  schema = file("bqtables/outlier_table_schema.json")
}

resource "google_bigquery_table" "normalized_centroid_data" {
  dataset_id = google_bigquery_dataset.anomaly_detection_presentation_ds.dataset_id
  table_id = "normalized_centroid_data"
  description = "Sample Normalized Data"
  schema = file("bqtables/normalized_centroid_data_schema.json")
}
