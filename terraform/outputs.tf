output "cluster_name" {
  value = google_container_cluster.angga_suriana_gke_cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.angga_suriana_gke_cluster.endpoint
}

output "gke_cluster_endpoint" {
  value = google_container_cluster.angga_suriana_gke_cluster.endpoint
}

output "gke_cluster_ca_certificate" {
  value = google_container_cluster.angga_suriana_gke_cluster.master_auth[0].cluster_ca_certificate
}

output "gke_access_token" {
  value     = data.google_client_config.default.access_token
  sensitive = true
}

