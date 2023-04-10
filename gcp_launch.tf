terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        versversion = "~> 4.37.0"
    }
  }
}

provider "google" {
    project = var.gcp_project_id
}

# kubernetes on GCP
resource "google_container_cluster" "primary" {
    name = "k8-cluster-01"
    location = var.gcp_region
    initial_node_count = 1
    enable_autopilot = true
    ip_allocation_policy {
      
    }
}

#database on gcp
resource "google_sql_database_instance" "instance" {
    name = "my-k8-database"
    region = var.gcp_region
    database_version = "MYSQL_8_0"
    settings {
      tier = "db-f1-micro"
    }

    deletion_protection = "true"
}

resource "google_sql_database" "database" {
    name = "my-database"
    instance = google_sql_database_instance.instance.name 
}