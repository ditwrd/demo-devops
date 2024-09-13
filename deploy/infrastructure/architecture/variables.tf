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
    "default" = "self-hosted-ditwrd",
    "staging" = "self-hosted-ditwrd",
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
