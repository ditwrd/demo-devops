# Service Account Outputs

output "tf_service_account_email" {
  description = "Email for Terraform service account"
  value       = google_service_account.tf_service_account.email
  sensitive   = true
}

output "tf_service_account_key" {
  description = "JSON Private Key for Terraform service account"
  value       = google_service_account_key.tf_service_account_key.private_key
  sensitive   = true
}

output "tf_service_roles" {
  description = "Roles attached to Terraform service account"
  value = [
    for role in google_project_iam_member.tf_service_account_role : role.role
  ]
  sensitive = true
}
