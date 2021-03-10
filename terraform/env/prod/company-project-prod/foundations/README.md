## Organization-wide Google Cloud Foundations 

## Requirements

| Name | Version |
|------|---------|
| terraform | >=0.13.4 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apis | List of APIs to enable in the main projects. | `list` | <pre>[<br>  "cloudbilling.googleapis.com",<br>  "serviceusage.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "compute.googleapis.com",<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "appengine.googleapis.com",<br>  "storage-api.googleapis.com",<br>  "monitoring.googleapis.com",<br>  "cloudresourcemanager.googleapis.com"<br>]</pre> | no |
| billing\_account | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| enforced-org-policies | n/a | `list` | <pre>[<br>  "compute.disableNestedVirtualization",<br>  "compute.disableSerialPortAccess",<br>  "compute.disableGuestAttributesAccess",<br>  "compute.skipDefaultNetworkCreation",<br>  "compute.restrictXpnProjectLienRemoval",<br>  "sql.restrictPublicIp",<br>  "iam.disableServiceAccountKeyCreation",<br>  "storage.uniformBucketLevelAccess"<br>]</pre> | no |
| external\_vms\_whitelist | The list of VMs allowed to use external IPs, every element of the list must be identified by the VM instance name, in the form: projects/PROJECT\_ID/zones/ZONE/instances/INSTANCE | `list` | `[]` | no |
| folders | Assuming a single level hierarchy for the organization, the name of the GCP folders that make up each environment | `list` | <pre>[<br>  "dev",<br>  "test",<br>  "prod"<br>]</pre> | no |
| iam\_domain\_members | Defines the set of members that can be added to Cloud IAM policies. The allowed/denied list must specify one or more Cloud Identity or G Suite customer IDs. Note that domain restricted sharing can interfere with some Google Cloud services, and you might need to provide exceptions for some Google Cloud services. | `list` | n/a | yes |
| main\_project\_name | The prefix that will make up the base projects per environment | `string` | `"company-project"` | no |
| org\_domain | Organization domain name | `string` | `"company.com"` | no |
| tf\_sa\_folder\_roles | List of permissions granted to Terraform service account within a GCP folder. | `list` | <pre>[<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.configWriter",<br>  "roles/resourcemanager.folderViewer",<br>  "roles/resourcemanager.projectCreator"<br>]</pre> | no |
| tf\_sa\_org\_roles | List of permissions granted to Terraform service account across the GCP organization. | `list` | <pre>[<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/billing.user",<br>  "roles/resourcemanager.organizationViewer"<br>]</pre> | no |

## Outputs

No output.
