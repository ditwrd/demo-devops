terraform {
  # Uncomment to add terraform backend
  # backend "gcs" {
  #   bucket      = "demo-devops-tf-state-bucket"
  #   credentials = "serviceAccount.json"
  # }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.83.0"
    }
  }
}

provider "google" {
  project = local.base_gcp_project_id
  region  = var.region
  zone    = var.zone
}

locals {
  base_gcp_project_id = "tugas-akhir-385807"

  project_service_pair_list = flatten([
    for env, project_id in var.gcp_project_id : [
      for service in var.enabled_service_list :
      {
        env        = env
        project_id = project_id
        service    = service
      }
    ]
  ])

  tf_project_role_pair_list = flatten([
    for env, project_id in var.gcp_project_id : [
      for role in var.tf_service_account_role_list :
      {
        env        = env
        project_id = project_id
        role       = role
      }
    ]
  ])

}

# GCS State Bucket
resource "google_storage_bucket" "tf_state_bucket" {
  name                     = "${var.project_name}-tf-state-bucket"
  project                  = local.base_gcp_project_id
  location                 = var.tf_state_bucket_geolocation
  storage_class            = "REGIONAL"
  force_destroy            = true
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

# Terraform Service Account
resource "google_service_account" "tf_service_account" {
  account_id   = "tf-sa-${var.project_name}"
  display_name = "Terraform Service Account"
  description  = "A service account used for terraform automation"
  project      = local.base_gcp_project_id
}


resource "google_service_account_key" "tf_service_account_key" {
  service_account_id = google_service_account.tf_service_account.id
  key_algorithm      = "KEY_ALG_RSA_2048"
  depends_on = [
    google_service_account.tf_service_account
  ]
}


resource "google_project_iam_member" "tf_service_account_role" {
  for_each = {
    for index, project_role_pair in local.tf_project_role_pair_list :
    "${project_role_pair.env}-${project_role_pair.role}" => project_role_pair
  }
  project = each.value.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.tf_service_account.email}"
  depends_on = [
    google_service_account.tf_service_account
  ]
}

# Enabled service for current project
resource "google_project_service" "enabled_service" {
  for_each = {
    for index, project_service_pair in local.project_service_pair_list :
    "${project_service_pair.env}-${split(".", project_service_pair.service)[0]}" => project_service_pair
  }
  service            = each.value.service
  project            = each.value.project_id
  disable_on_destroy = false
}

