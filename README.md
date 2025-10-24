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
```

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

| Tag                         | Required  | Description                                     |
|-----------------------------|-----------|-------------------------------------------------|
| Environment                 | Yes       | dev, staging, prod                              |
| Owner                       | Yes       | Team or individual responsibility               |
| CostCenter                  | Yes       | Billing/chargeback code                         |
| Application                 | Yes       | Application or service name                     |
| ManagedBy                   | Auto      | Always "Terraform"                              |
| CreatedDate                 | Auto      | ISO 8601 creation timestamp                     |
| DataClassification          | Prod Only | public, internal, confidential                  |

### Policy Assignments

The following policies are enforced at the resource group level:

1. **Require Tags** (`enforce_tagging = true`)
   - Ensures all resources have required tags
   - Configurable tag list

2. **Allowed Locations** (`enforce_allowed_locations = true`)
   - Restricts resource deployment to approved regions
   - Prevents data residency violations

3. **Require Encryption** (`enforce_encryption = true`)
   - Enforces encryption for storage accounts
   - Ensures data at rest protection

4. **Audit Diagnostic Settings** (`enable_diagnostic_audit = true`)
   - Identifies resources without diagnostic logging
   - Improves observability and compliance
  
## 🚀 CI/CD Integration

### Github Actions

The project includes a complete Github Actions workflow(`.github/workflow/terraform.yml`) with:

- **Automated Planning**: Plan generation for all environments
- **Security Scanning**: Checkov, TFSec, and Terrascan integration
- **Multi-Stage Deployment**: Dev -> Staging -> Production promotion
- **Approval Gates**: Manual approval for production deployments
- **PR Comments**: Automatic plan comments on pull requests

#### Required Secrets

Configure these secrets in your Github repository: 

```
ARM_CLIENT_ID
ARM_CLIENT_SECRET
ARM_SUBSCRIPTION_ID
ARM_TENANT_ID
BACKEND_RESOURCE_GROUP
BACKEND_STORAGE_ACCOUNT
BACKEND_CONTAINER
```

### Azure DevOps

Azure Pipelines configuration (`pipelines/azure-pipelines.yml`) provides:

- **Multi-Stage Pipeline**: Validate → Scan → Plan → Deploy
- **Environment Approvals**: Built-in environment protection
- **Security Scanning**: Integrated Checkov and TFSec
- **Artifact Management**: Plan file preservation between stages

#### Required Variables

Configure these in Azure DevOps Library or Pipeline Variables:

BACKEND_RESOURCE_GROUP
BACKEND_STORAGE_ACCOUNT
BACKEND_CONTAINER

#### Required Service Connection

Create an Azure Service Connection named `Azure-Service-Connection` with appropriate permissions.

## 🧩 Extending the Landing Zone

### Adding a New Module

1. Create module directory under `modules/`
2. Implement `main.tf`, `variables.tf`, `outputs.tf`
3. Document module in `README.md`
4. Reference module in root `main.tf`
5. Update root variables and outputs

Example:

```hcl
# modules/my-new-module/main.tf
resource "azurerm_resource" "example" {
name                = var.name
resource_group_name = var.resource_group_name
location            = var.location
}
```


### Adding a New Environment

1. Create directory: `environments/{environment}/`
2. Copy and customize `terraform.tfvars`
3. Update CI/CD pipelines to include new environment
4. Configure backend for new state file

```bash
mkdir -p environments/uat
cp environments/staging/terraform.tfvars environments/uat/
# Edit environments/uat/terraform.tfvars
```

### Adding Custom Policy

```hcl
# In modules/azure-policy/main.tf
resource "azurerm_policy_definition" "custom" {
  name         = "custom-policy-name"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Custom Policy Display Name"

  policy_rule = jsonencode({
    if = {
      # Your policy condition
    }
    then = {
      effect = "deny"   # or "audit", "append", etc.
    }
  })
}
```

### Adding Subnets

Update your environment's `terraform.tfvars`:

```hcl
subnets = {
  existing_subnet = {
    # ... existing config
  }
  new_subnet = {
    name              = "snet-newsubnet"
    address_prefixes  = ["10.0.5.0/24"]
    service_endpoints = ["Microsoft.Storage"]
    nsg_rules = [
      {
        name                      = "AllowSpecificTraffic"
        priority                  = 100
        direction                 = "Inbound"
        access                    = "Allow"
        protocol                  = "Tcp"
        source_port_range         = "*"
        destination_port_range    = "443"
        source_address_prefix     = "10.0.1.0/24"
        destination_address_prefix= "*"
      }
    ]
  }
}
```

## Testing

### Pre-Deployment Validation

```bash
# Format check
terraform fmt --check --recursive

# Validation
terraform validate

# Security scan with Checkov
checkov -d . --framework terraform

# Security scan with TFSec
tfsec .

# Generate documentation
terraform-docs markdown table . > TERRAFORM.md
```

### Post-Deployment Verification

```bash
# Verify resource creation
az group list --output table

# Check network configuration
az network vnet list --resource-group rg-landingzone-prod-001 --output table

# Verify Key Vault
az keyvault list --resource-group rg-landingzone-prod-001 --output table

# Check policy assignments
az policy assignment list --resource-group rg-landingzone-prod-001 --output table
```

## 📖 Module Documentation

Each module includes detailed documentation:

- [Resource Group Module](./modules/resource-group/README.md)
- [Networking Module](./modules/networking/README.md)
- [Azure Policy Module](./modules/azure-policy/README.md)
- [Key Vault Module](./modules/key-vault/README.md)
- [IAM Module](./modules/iam/README.md)

## 🤝 Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and validation
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- HashiCorp for Terraform
- Microsoft Azure for cloud platform
- Azure Landing Zone architecture best practices
- Cloud Adoption Framework (CAF)

## 📞 Support

For issues, questions, or contributions:

- **Issues**: [GitHub Issues](https://github.com/your-org/azure-landing-zone/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-org/azure-landing-zone/discussions)