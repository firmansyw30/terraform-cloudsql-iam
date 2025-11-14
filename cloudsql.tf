resource "google_sql_database" "database" {
  name     = "my-postgresql-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name             = "my-postgresql-database-instance"
  region           = "us-central1"
  database_version = "POSTGRES_17"
  settings {
    tier = "db-f1-micro"
    edition = "ENTERPRISE"
    backup_configuration {
      enabled                        = true
      start_time                     = "00:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
    }

    final_backup_config {
      enabled        = true
      retention_days = 7
    }

    availability_type = "ZONAL"
    disk_size         = 20
    disk_type         = "PD_HDD"
  }
  # set `deletion_protection` to true, will ensure that one cannot accidentally delete this instance by
  # use of Terraform whereas `deletion_protection_enabled` flag protects this instance at the GCP level.
  deletion_protection = false
}