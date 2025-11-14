# 1. Define the custom role for "Backup Admin"
resource "google_project_iam_custom_role" "cloudsql_backup_admin" {
  project     = var.project_id
  role_id     = "cloudSqlBackupAdmin"
  title       = "Cloud SQL Backup Admin"
  description = "Allows creating, listing, and restoring Cloud SQL backups"
  
  # These are the specific permissions needed for backup operations
  permissions = [
    "cloudsql.backupRuns.create",
    "cloudsql.backupRuns.delete",
    "cloudsql.backupRuns.get",
    "cloudsql.backupRuns.list",
    "cloudsql.instances.restoreBackup"
  ]
}

# 2. Create the Service Account identity
resource "google_service_account" "backup_manager_sa" {
  project      = var.project_id
  account_id   = "cloudsql-backup-manager"
  display_name = "Cloud SQL Backup Manager SA"
  description  = "Service account to trigger and restore Cloud SQL backups"
}

# 3. Assign your NEW custom role to the service account
resource "google_project_iam_member" "backup_admin_custom_role_binding" {
  project = var.project_id
  
  # Reference the custom role you just created
  role    = google_project_iam_custom_role.cloudsql_backup_admin.id
  
  member  = "serviceAccount:${google_service_account.backup_manager_sa.email}"
}