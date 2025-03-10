resource "google_service_account" "angga_suriana_gke_sa" {
  account_id   = "angga-suriana-gke-sa"
  display_name = "GKE Workload Identity SA"
}

resource "google_compute_network" "angga_suriana_vpc" {
  name                    = "angga-suriana-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "angga_suriana_subnet" {
  name          = "angga-suriana-subnet"
  network       = google_compute_network.angga_suriana_vpc.id
  region        = var.region
  ip_cidr_range = "10.20.0.0/20"
}

resource "google_container_cluster" "angga_suriana_gke_cluster" {
  name     = "angga-suriana-gke-cluster"
  location = var.zone
  networking_mode = "VPC_NATIVE"
  
  network    = google_compute_network.angga_suriana_vpc.name
  subnetwork = google_compute_subnetwork.angga_suriana_subnet.name
  
  deletion_protection = false
  remove_default_node_pool = true
  initial_node_count = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "angga_suriana_gke_node_pool" {
  name     = "angga-suriana-node-pool"
  cluster  = google_container_cluster.angga_suriana_gke_cluster.id
  location = var.zone

  node_config {
    disk_size_gb = 60
    disk_type    = "pd-ssd"
    machine_type = "e2-medium"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  node_count = 2
}

resource "kubernetes_namespace" "angga_suriana_namespace" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }
  
  depends_on = [google_container_cluster.angga_suriana_gke_cluster, google_container_node_pool.angga_suriana_gke_node_pool]
}

resource "kubernetes_service_account" "angga_suriana_ksa" {
  for_each = toset(var.namespaces)

  metadata {
    name      = "angga-suriana-ksa"
    namespace = each.value
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.angga_suriana_gke_sa.email
    }
  }

  depends_on = [kubernetes_namespace.angga_suriana_namespace]
}

resource "google_project_iam_binding" "angga_suriana_iam_binding" {
  for_each = toset(var.namespaces)
  project  = var.project_id
  role     = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${each.value}/angga-suriana-ksa]"
  ]

  depends_on = [kubernetes_service_account.angga_suriana_ksa]
}