terraform {
  required_version = ">=0.13.0"
  backend "gcs" {
    prefix = "${var.project_id}/global/"
    bucket = "${var.project_id}-tfstate"
  }
}

provider "google" {
  project = "${var.project_id}"
}
