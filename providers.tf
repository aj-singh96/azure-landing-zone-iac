terraform {
    required_verion = ">= 1.5.0"

    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "~> 3.0"
        }
    }

    backend "azurerm" {
        # Backend configuration is provided via backend config file or command line
        # Example: terraform init -backend-config=backend.hcl
    }
}

provider "azurerm" {
    features {
        resource_group {
            prevent_deletion_if_contains_resources = true
        }

        key_vault {
            purge_soft_delete_on_destroy     = false
            recover_soft_deleted_key_vaults  = true
        }

        virtual_machine {
            delete_os_disk_on_deletion    = true
            graceful_shutdown             = false
            skip_shutdown_and_force_delete = false
        }
    }

    skip_provider_registration = var.skip_provider_registration
}