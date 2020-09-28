provider "google" {
  credentials = file("/home/serhii/Documents/configs/gcp/anomaly-detection-presentation-terraform-operator.json")
  project = var.project_id
  region  = var.region
}