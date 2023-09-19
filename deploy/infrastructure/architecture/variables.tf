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
    "default" = "tugas-akhir-385807",
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

