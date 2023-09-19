output "server_ip" {
  description = "Server IP"
  value       = google_compute_instance.main_server.network_interface.0.access_config.0.nat_ip
}
