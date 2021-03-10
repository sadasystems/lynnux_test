resource "google_organization_policy" "bool" {
  for_each   = toset(var.enforced-org-policies)
  org_id     = data.google_organization.default.org_id
  constraint = each.value
  boolean_policy {
    enforced = true
  }
  depends_on = [
    google_service_account.terraform,
  ]
}
resource "google_organization_policy" "iam_domain_members" {
  org_id     = data.google_organization.default.org_id
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      values = var.iam_domain_members
    }
  }
}
resource "google_organization_policy" "allowed_external_vms" {
  org_id     = data.google_organization.default.org_id
  constraint = "compute.vmExternalIpAccess"

  dynamic "list_policy" { # Default deny all
    for_each = length(var.external_vms_whitelist) > 0 ? [] : [1]
    content {
      deny {
        all = true
      }
    }
  }
  dynamic "list_policy" { # Enable VM whitelist if values are passed in
    for_each = length(var.external_vms_whitelist) > 0 ? [1] : []
    content {
      allow {
        values = var.external_vms_whitelist
      }
    }
  }
}
