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