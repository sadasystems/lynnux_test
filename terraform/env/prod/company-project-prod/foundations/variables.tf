variable org_domain {
  type        = string
  description = "Organization domain name"
}
variable billing_account {
  type        = string
  description = "The ID of the billing account to associate projects with."
}
variable main_project_name {
  type        = string
  description = "The prefix that will make up the base projects per environment"
}
variable folders {
  type        = list
  description = "Assuming a single level hierarchy for the organization, the name of the GCP folders that make up each environment"
  default     = ["dev", "test", "prod"]
}
variable tf_sa_folder_roles {
  type        = list
  description = "List of permissions granted to Terraform service account within a GCP folder."
  default = [
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.configWriter",
    "roles/resourcemanager.folderViewer",
    "roles/resourcemanager.projectCreator"
  ]
}
variable tf_sa_org_roles {
  type        = list
  description = "List of permissions granted to Terraform service account across the GCP organization."
  default = [
    "roles/orgpolicy.policyAdmin",
    "roles/billing.user",
    "roles/resourcemanager.organizationViewer"
  ]
}
variable enforced-org-policies {
  type = list
  default = [
    "compute.disableNestedVirtualization",
    "compute.disableSerialPortAccess",
    "compute.disableGuestAttributesAccess",
    "compute.skipDefaultNetworkCreation",
    "compute.restrictXpnProjectLienRemoval",
    "sql.restrictPublicIp",
    "iam.disableServiceAccountKeyCreation",
    "storage.uniformBucketLevelAccess"
  ]
}
variable iam_domain_members {
  type        = list
  default     = ["01islvcf"] # sada domain id
  description = "Defines the set of members that can be added to Cloud IAM policies. The allowed/denied list must specify one or more Cloud Identity or G Suite customer IDs. Note that domain restricted sharing can interfere with some Google Cloud services, and you might need to provide exceptions for some Google Cloud services."
}
variable external_vms_whitelist {
  type        = list
  default     = []
  description = "The list of VMs allowed to use external IPs, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"
}
variable apis {
  type        = list
  description = "List of APIs to enable in the main projects."
  default = [
    "cloudbilling.googleapis.com",
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}
