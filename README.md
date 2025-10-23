# Azure Landing Zone – Terraform Infrastructure as Code

[![Terraform](https://img.shields.io/badge/Terraform-1.5%2B-623CE4?logo=terraform)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure_Cloud-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-ready, enterprise-grade Azure landing zone implemented using Terraform. This project provides a secure, scalable, and well-governed foundation for deploying workloads on Microsoft Azure.

## 🏗 Architecture Overview

This landing zone establishes a comprehensive Azure environment with the following core components:

```
+----------------------+
|  Azure Subscription  |
+----------------------+
        |
        v
+----------------------+
|    Resource Group    |
|  +---------------------------------------+  |
|  |       Virtual Network (VNet)          |  |
|  |  +-----------+   +-----------+        |  |
|  |  | Frontend  |   | Backend   |        |  |
|  |  | Subnet    |   | Subnet    |        |  |
|  |  | + NSG     |   | + NSG     |        |  |
|  |  +-----------+   +-----------+        |  |
|  |  +-----------+   +-----------+        |  |
|  |  | Management|   | Database  |        |  |
|  |  | Subnet    |   | Subnet    |        |  |
|  |  | + NSG     |   | + NSG     |        |  |
|  |  +-----------+   +-----------+        |  |
|  +---------------------------------------+  |
|                                              |
|  Azure Key Vault                             |
|    - RBAC Authorization                      |
|    - Private Endpoint                        |
|    - Network ACLs (Deny by default)          |
|                                              |
|  Azure Policy Assignments                    |
|    - Required Tags                           |
|    - Allowed Locations                       |
|    - Encryption Enforcement                  |
|    - Diagnostic Settings Audit               |
|                                              |
|  IAM (RBAC) Role Assignments                 |
|    - Built-in Roles                          |
|    - Custom Roles                            |
+----------------------------------------------+
```

## ⭐ Key Features

- **Security by Default**: Network ACLs set to deny, NSG rules required for access, encryption enforced
- **Modular Design**: Reusable Terraform modules for easy extension and maintenance
- **Governance**: Azure Policy enforcement for tags, locations, and compliance
- **Identity & Access**: RBAC-based access control with support for custom roles
- **Network Isolation**: Multiple subnets with dedicated NSGs and service endpoints
- **Secrets Management**: Azure Key Vault with private endpoints and RBAC
- **Observability**: Diagnostic settings and monitoring integration
- **CI/CD Ready**: GitHub Actions and Azure DevOps pipelines included
- **Multi-Environment**: Separate configurations for dev, staging, and production

## 📁 Project Structure

```
modules/
├── resource-group/     # Resource group module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── networking/         # VNet, subnets, NSGs module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── azure-policy/       # Azure Policy assignments
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── key-vault/          # Azure Key Vault module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── iam/                # IAM/RBAC module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
    environments/                    # Environment-specific configurations
    ├── dev/
    │   └── terraform.tfvars
    ├── staging/
    │   └── terraform.tfvars
    └── prod/
        └── terraform.tfvars
    .github/workflows/               # GitHub Actions pipelines
    │   └── terraform.yml
    pipelines/                       # Azure DevOps pipelines
    │   └── azure-pipelines.yml
    main.tf                          # Root module configuration
    providers.tf                     # Provider configuration
    variables.tf                     # Root variables
    outputs.tf                       # Root outputs
    backend.hcl                      # Backend configuration
    terraform.tfvars.example         # Example variables file
    .gitignore
    LICENSE
    CONTRIBUTING.md
    README.md

## 🚀 Quick Start

### Prerequisites

1. **Terraform** >= 1.5.0 ([Install Terraform](https://developer.hashicorp.com/terraform/downloads))
2. **Azure CLI** ([Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
3. **Azure Subscription** with appropriate permissions
4. **Service Principal** for authentication (for CI/CD)

### Initial Setup

#### 1. Clone the Repository

```bash
git clone https://github.com/your-org/azure-landing-zone.git
cd azure-landing-zone
```

#### 2. Set Up Backend Storage

Create an Azure Storage Account for Terraform state:

```bash
# Set variables
RESOURCE_GROUP_NAME="rg-terraform-state"
STORAGE_ACCOUNT_NAME="tfstate$(openssl rand -hex 3)"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create \
--resource-group $RESOURCE_GROUP_NAME \
--name $STORAGE_ACCOUNT_NAME \
--sku Standard_LRS \
--encryption-services blob

# Create blob container
az storage container create \
--name $CONTAINER_NAME \
--account-name $STORAGE_ACCOUNT_NAME
```

#### 3. Configure Backend

Update `backend.hcl` with your storage account details:

```hcl
resource_group_name   = "rg-terraform-state"
storage_account_name  = "tfstateXXXXXX"    # Your unique name
container_name        = "tfstate"
key                   = "landing-zone.tfstate"
```


#### 4. Configure Variables

Copy the example variables file and customize:


```bash
cp terraform.tfvars.example terraform.tfvars
```


Edit `terraform.tfvars` with your values:


```hcl
environment        = "dev"
location           = "eastus"
resource_group_name= "rg-landingzone-dev-001"
# ... additional configuration
```


#### 5. Authenticate with Azure

```bash
az login
az account set --subscription "YOUR-SUBSCRIPTION-ID"
```


#### 6. Initialize Terraform

```bash
terraform init -backend-config=backend.hcl
```

#### 7. Validate Configuration

```bash
terraform validate
terraform fmt --recursive
```

#### 8. Plan Deployment

```bash
terraform plan --out=tfplan
```

#### 9. Apply Infrastructure

```bash
terraform apply tfplan
```

##🌐 Multi-Environment Deployment

This landing zone supports separate configurations for multiple environments:

### Deploy to Development

```bash
terraform workspace new dev  # Create workspace if needed
terraform plan -var-file=environments/dev/terraform.tfvars
terraform apply -var-file=environments/dev/terraform.tfvars
```

### Deploy to Staging

```bash
terraform workspace new staging
terraform plan -var-file=environments/staging/terraform.tfvars
terraform apply -var-file=environments/staging/terraform.tfvars
```

### Deploy to Production

```bash
terraform workspace new prod
terraform plan -var-file=environments/prod/terraform.tfvars
terraform apply -var-file=environments/prod/terraform.tfvars
```

## 🏷️ Naming Conventions

This project follows Azure naming best practices:

### Resource Naming Pattern

```
<resource-type>-<workload>-<environment>-<region>-<instance>
```

### Examples

- Resource Group: `rg-landingzone-prod-eus-001`
- Virtual Network:  `vnet-landingzone-prod-eus-001`
- Subnet: `snet-frontend-prod-eus-001`
- Key Vault: `kv-lz-prod-eus-001` (max 24 chars)
- NSG: `nsg-frontend-prod-eus-001`

### Resource Type Abbreviations

| Resource                  | Abbreviation |
|---------------------------|--------------|
| Resource Group            | rg           |
| Virtual Network           | vnet         |
| Subnet                    | snet         |
| Network Security Group    | nsg          |
| Key Vault                 | kv           |
| Storage Account           | st           |
| Log Analytics             | log          |
| Application Insights      | appi         |

### Environment Abbreviations

- Development: `dev`
- Staging: `staging`
- Production: `prod`

## 🛡️ Security Considerations

### Network Security

- **Default Deny**: All NSGs include a default deny-all inbound rule
- **Explicit Allow**: Only explicitly defined traffic is permitted
- **Service Endpoints**: Enabled for Azure services (Key Vault, Storage, SQL)
- **Private Subnets**: Backend subnets have no direct internet access

### Key Vault Security

- **RBAC Authorization**: Uses Azure RBAC instead of access policies (recommended)
- **Network Restrictions**: Default action is Deny with explicit allow list
- **Private Endpoints**: Supported for private network access
- **Purge Protection**: Enabled in production to prevent accidental deletion
- **Soft Delete**: 90-day retention for deleted secrets

### Azure Policy Enforcement

- **Required Tags**: Enforce organizational tagging standards
- **Allowed Locations**: Restrict deployments to approved regions
- **Encryption**: Require encryption for storage accounts
- **Diagnostic Settings**: Audit resources without monitoring enabled

### Identity & Access Management

- **Principle of Least Privilege**: Assign minimum required permissions
- **RBAC over Access Policies**: Use Azure RBAC for all supported services**Custom Roles**: Create tailored roles for specific workloads**Regular Audits**: Review and audit role assignments quarterly

## 🏛️ Governance Model

### Tagging Strategy

All resources are tagged with: