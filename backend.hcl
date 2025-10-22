# Backend configuration for Terraform state
# This file can be used with: terraform init -backend-config=backend.hcl

resource_group_name  = "rg-terraform-state"
storage_account_name = "sttfstateXXXXX" # Replace XXXXX with unique identifier
container_name       = "tfstate"
key                  = "landing-zone.tfstate"