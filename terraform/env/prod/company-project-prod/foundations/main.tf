terraform {
  required_version = ">=0.13.4"
  #backend "gcs" {
  #  prefix = "<PROD_PROJECT_ID>foundations/"
  #  bucket = "<PROD_PROJECT_ID>-tfstate"
  #}
}

provider "google" {
}

### GCP Top Level Folders per Environment ###
resource "google_folder" "environments" {
  for_each     = toset(var.folders)
  display_name = each.key
  parent       = "organizations/${data.google_organization.default.org_id}"
}

### GCP Main Projects per Environment ###
resource "google_project" "main" {
  for_each            = toset(var.folders)
  name                = "${var.main_project_name}-${each.key}"
  project_id          = "${var.main_project_name}-${each.key}"
  folder_id           = google_folder.environments[each.key].name
  billing_account     = var.billing_account
  skip_delete         = true
  auto_create_network = false

  labels = {
    terraform = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

### Enable GCP Service APIs for main projects ###
resource "google_project_service" "cloudbuild_apis" {
  for_each           = local.project_api_map
  project            = google_project.main[each.value.env].project_id
  service            = each.value.api
  disable_on_destroy = false
}

### GCS Bucket for Terraform State per Environment ###
resource "google_storage_bucket" "tfstate" {
  for_each                    = toset(var.folders)
  name                        = "${var.main_project_name}-${each.key}-tfstate"
  project                     = google_project.main[each.key].project_id
  uniform_bucket_level_access = true
  force_destroy               = true
  lifecycle {
    prevent_destroy = true
  }
}

### Terraform Service Account per Environment ###
locals {
  project_api_map = {
    for item in setproduct(var.folders, var.apis) : join("-", flatten(item)) => {
      env = item[0]
      api = item[1]
    }
  }
  tf_sa_folder_map = {
    for item in setproduct(var.folders, var.tf_sa_folder_roles) : join("-", flatten(item)) => {
      env  = item[0]
      role = item[1]
    }
  }
  tf_sa_org_map = {
    for item in setproduct(var.folders, var.tf_sa_org_roles) : join("-", flatten(item)) => {
      env  = item[0]
      role = item[1]
    }
  }
}

resource "google_service_account" "terraform" {
  for_each     = toset(var.folders)
  account_id   = "terraform-sa-${each.key}"
  display_name = "Service account for Terraform in ${each.key} environment"
  project      = google_project.main[each.key].project_id
}

resource "google_service_account_key" "terraform" {
  for_each           = toset(var.folders)
  service_account_id = google_service_account.terraform[each.key].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

### Terraform Service Account Roles ###
resource "google_project_iam_member" "terraform" {
  for_each = toset(var.folders)
  role     = "roles/owner"
  member   = "serviceAccount:${google_service_account.terraform[each.key].email}"
  project  = google_project.main[each.key].project_id
}

resource "google_folder_iam_member" "terraform" {
  for_each = local.tf_sa_folder_map
  role     = each.value.role
  member   = "serviceAccount:${google_service_account.terraform[each.value.env].email}"
  folder   = google_folder.environments[each.value.env].name
}

resource "google_organization_iam_member" "terraform" {
  for_each = local.tf_sa_org_map
  org_id   = data.google_organization.default.org_id
  role     = each.value.role
  member   = "serviceAccount:${google_service_account.terraform[each.value.env].email}"
}

resource "google_storage_bucket_iam_member" "terraform" {
  for_each = toset(var.folders)
  bucket   = google_storage_bucket.tfstate[each.key].name
  role     = "roles/storage.admin"
  member   = "serviceAccount:${google_service_account.terraform[each.key].email}"
}
