## SADA Foundations Infrastructure as Code Template

**This template follows a flat level GCP hierarchy. There are plans to change this template so it can handle a multilevel hierarchy and incorporate other core patterns and features. This template is still being improved upon and is a work in progress!!**

```
├── README.md
└── terraform
    ├── env
    │   ├── dev
    │   │   └── company-project-dev
    │   │       ├── README.md
    │   │       ├── global
    │   │       │   ├── main.tf
    │   │       │   ├── modules.tf
    │   │       │   └── variables.tf
    │   │       └── us-west2
    │   ├── prod
    │   │   └── company-project-prod
    │   │       └── foundations <-------------- START HERE!
    │   │           ├── README.md
    │   │           ├── data.tf
    │   │           ├── main.tf
    │   │           ├── org-policies.tf
    │   │           └── variables.tf
    │   └── test
    │       └── company-project-test
    │           └── global
    │               ├── main.tf
    │               ├── modules.tf
    │               └── variables.tf
    └── modules
        ├── project
        │   ├── README.md
        │   ├── main.tf
        │   └── variables.tf
        └── vpc
            ├── README.md
            ├── main.tf
            ├── outputs.tf
            ├── variables.tf
            └── versions.tf
```

## Table of Contents

**Modules**
- [project](./terraform/modules/project/)
- [vpc](./terraform/modules/vpc/)

## Standardization
- GCP Project IDs and Names should match (therefore ensure an immutable and unique id/name)
- structure should match for GCP org, this repository, and the GCS bucket for terraform state

## Deployment
**Organization Foundations:**
- Create a `terraform.tfvars` file with the customer-specific variables:

```
### terraform.tfvars example ###

org_domain      = "Company.com"
billing_account = "000000-000000-000000" # Provided by TAM
main_project_name  = "company-project" # Will create company-project-dev, company-project-test, company-project-prod
iam_domain_members = ["C01islvcf", "C01jgtznq"] # Provided by TAM
```

- Copy `terraform.tfvars` to the foundations directory:
    - `cp ./terraform.tfvars terraform/env/prod/company-project-prod/foundations`
- Ensure correct roles for account that will provision foundations
    - billing account user for billing project that will be connected (can be provided by SADA TAM)
    - organization admin of customer GCP org
- Prepare workstation with credentials to run terraform
    - `gcloud auth application-default login`
- `terraform plan` and `terraform apply` in `terraform/env/prod/company-project-prod/foundations` first in order to set up base GCP organization environment folders, attach billing, shared projects, and deploy organization-wide resources (ex: GCS per env for terraform state & Terraform service accounts to read/write to bucket from other projects)
- Apply once with terraform backend commented out, uncomment, and reapply once GCS bucket has been created

## Customers
- LoadSpring

## References
- [Customizing the Invented Wheel](https://github.com/terraform-google-modules/cloud-foundation-fabric/tree/master/foundations/environments)
- [Cloud Foundation Toolkit](https://registry.terraform.io/namespaces/terraform-google-modules)
- [Google's Best Practices for Enterprise Organizations](https://cloud.google.com/docs/enterprise/best-practices-for-enterprise-organizations)
- [Google's Onboarding Checklist](https://cloud.google.com/docs/enterprise/onboarding-checklist)
