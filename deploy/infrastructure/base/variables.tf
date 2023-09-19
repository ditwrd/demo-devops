# Global Variables 

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "demo-devops"
}


variable "gcp_project_id" {
  description = "Map of GCP Project ID base on its environment"
  type        = map(string)
  default = {
    "staging" = "tugas-akhir-385807",
  }

}


variable "zone" {
  description = "GCP Zone for this project"
  type        = string
  default     = "asia-southeast2-a"
}

variable "region" {
  description = "GCP Region for this project"
  type        = string
  default     = "asia-southeast2"
}

# GCS Bucket Variables

variable "tf_state_bucket_geolocation" {
  description = "Terrafrom state bucket geolocation"
  type        = string
  default     = "ASIA-SOUTHEAST2" #Jakarta
}


# Service Account Variables

variable "tf_service_account_role_list" {
  description = "List of role access for Terraform Service Account"
  type        = list(string)
  default = [
    "roles/compute.admin",        # Compute
    "roles/compute.networkAdmin", # Compute Network
    "roles/storage.objectAdmin",  # Cloud Storage
  ]
}


# Service Enable Variables

variable "enabled_service_list" {
  description = "A list of services used for the current project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "storage-component.googleapis.com"
  ]
}
