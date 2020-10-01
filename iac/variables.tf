variable "topic_id" {
  description = "Pub/Sub topic Id"
  type        = string
}

variable "subscription_id" {
  description = "Pub/Sub topic subscription Id"
  type        = string
}

variable "project_id" {
  description = "Google Project ID."
  type        = string
}

variable "project_number" {
  description = "Google Project Number"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
  default     = "europe-west2"
}