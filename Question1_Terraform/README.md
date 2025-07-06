# Azure Storage Account with Private Endpoint - Terraform Project
This Terraform project creates a secure Azure Storage Account and Storage Container with private endpoint connectivity, monitoring, and role-based access control.

## Project Structure
```
TerraformProject/main/
├── main.tf                 # Root module configuration
├── variables.tf            # Input variables
├── provider.tf             # Provider configuration
├── backend.tf              # Local state configuration
├── dev.tfvars              # Development environment variables
├── modules/
│   ├── storage/            # Storage module
│   │   ├── main.tf         # Storage resources
│   │   ├── variables.tf    # Storage variables
│   │   ├── outputs.tf      # Storage outputs
│   │   └── locals.tf       # Storage naming convention
│   └── observability/      # Monitoring module
│       ├── main.tf         # Log Analytics & diagnostics
│       ├── variables.tf    # Monitoring variable
│       └── locals.tf       # Monitoring naming convention
```
## Project Overview
This project provisions:
- Storage Module:
- **Storage Account** with private container
- **Private Endpoint** for secure VNet-only access
- **Virtual Network** with subnet and private DNS configuration
- **Role Assignments** for access control
- Observability Module:
- **Log Analytics Workspace** for storage and analysis of log diagnostics
- **Monitor Log Diagnostics** for monitoring and diagnostics


## Security Features
Storage account is only accessible via  private endpoint, for maximum security. Ednpoint is being resolved in the DNS name zone on which the autoregistration feature is disabled.
Plus, nested item of the storage account, in our case the container, is set to be private and public network access is also disabled.

### Private Connectivity
- **Private Endpoint** - Storage account is only accessible from within the VNet
- **Private DNS Zone** - Automatic DNS resolution for private endpoint IP addresses
- **Network Security** - No internet access to storage account required

### Access Control
- **Role Assignments** - RBAC for users and service principals
- **Container Access** - Private container with no public access
- **Service Principal** - Automatic Owner role for deployment identity


## Observability Features
A log analytics workspace is provisioned, which hosts the logs and metrics of the storage account, stored in separate tables.
The metrics and logs are built dynamically, after querying the storage account created using the data function, and retrieving the available metric and logs.

### Monitoring
- **Log Analytics** - Centralized logging and monitoring
- **Diagnostic Settings** - Comprehensive logging of storage account activities
- **Retention Policies** - Configurable log retention periods


## Prerequisites
Before using this project, ensure you have:

### Software Requirements
- **Terraform** >= 1.0.0 ([Download](https://www.terraform.io/downloads))
- **PowerShell** (for Windows users) or **Bash** (for Linux/Mac users)
- **Azure CLI** >= 2.30.0 ([Install Guide](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))

### Azure Requirements
- **Azure Subscription** (demo subscription works perfectly)
- **Azure CLI authentication** via `az login`
- **Basic permissions** to read subscription information (for planning)

> **Note**: This project uses Azure CLI authentication for planning. A demo subscription is sufficient since we're only running `terraform plan` to validate the configuration.

## Quick Start
Get up and running in 5 minutes:

```bash
# 1. Connect to Azure Subscription (demo subscription is fine)
az login

# 2. Verify your subscription access
az account show

# 3. Initialize Terraform
terraform init

# 4. Plan the deployment (safe - no changes made)
terraform plan -var-file="dev.tfvars" -out=tfplan.binary

# 5. Review the plan in readable format
terraform show tfplan.binary > tfplan.txt

# 6. Open tfplan.txt in your editor to review changes
```

**That's it!** You now have a complete execution plan showing exactly what will be created.

## How Variables Work
The `dev.tfvars` file contains all the configuration values for your infrastructure:

### Variable Flow
```
dev.tfvars → Root Variables → Module Variables → Resource Names
```


### How Modules Use Variables
- **Storage Module**: Uses naming variables to create `sre-challenge-flaschenpost` resource group
- **Observability Module**: Uses naming variables to create `log-sre-challenge-flaschenpost` workspace
- **Both Modules**: Share the same `location` and naming convention for consistency

## Naming Convention
All resources follow a consistent naming pattern based on three core variables:
- `department` - Department name (e.g., "sre")
- `project` - Project name (e.g., "challenge") 
- `company` - Company name (e.g., "flaschenpost")

#hint
   Storage account's name was supposed to be srechallengeforflaschenpost, but azure allows a name to be up to 27 characters, thus i removed the 'for' and set it as 'srechallengeflaschenpost'.

### Resource Naming Patterns
| Resource Type | Pattern | Example |
|---------------|---------|---------|
| Resource Group | `{department}-{project}-{company}` | `sre-challenge-flaschenpost` |
| Storage Account | `{department}{project}{company}` | `srechallengeflaschenpost` |
| Virtual Network | `vnet-{department}-{project}-{company}` | `vnet-sre-challenge-flaschenpost` |
| Subnet | `sub-{department}-{project}-{company}` | `sub-sre-challenge-flaschenpost` |
| Private Endpoint | `pvt-endpoint-{department}-{project}-{company}` | `pvt-endpoint-sre-challenge-flaschenpost` |
| Log Analytics Workspace | `log-{department}-{project}-{company}` | `log-sre-challenge-flaschenpost` |

## Variables

### Required Variables
- `address_space` - Virtual network address space (e.g., `["10.0.0.0/24"]`)
- `address_prefixes` - Subnet address prefixes (e.g., `["10.0.0.0/27"]`)
- `dns_servers` - DNS servers for the VNet (e.g., `["10.0.0.4","10.0.0.5"]`)

### Optional Variables
- `department` - Department name (default: "sre")
- `project` - Project name (default: "challenge")
- `company` - Company name (default: "flaschenpost")
- `location` - Azure region (default: "westeurope")
- `rg_readers` - List of users with Reader access to Resource Group
- `stg_owners` - List of users with Owner access to Storage Account

## Outputs
After successful deployment, this project provides the following outputs:

| Output Name | Description | Example Value |
|-------------|-------------|---------------|
| `resource_group_name` | Name of the created resource group | `sre-challenge-flaschenpost` |
| `stg_id` | Full Azure resource ID of the storage account | `/subscriptions/.../storageAccounts/srechallengeflaschenpost` |
| `stg_primary_access_key` | Primary access key for the storage account | `ZXhhbXBsZWtleWZvcnN0b3JhZ2U=` |
| `stg_primary_connection_string` | Connection string for applications | `DefaultEndpointsProtocol=https;AccountName=...` |
| `container_id` | ID of the private container | `/subscriptions/.../blobServices/default/containers/sre` |

## State Management

This project uses **local state storage** for simplicity:
- **State File**: `terraform.tfstate` (stored locally)
- **Location**: Same directory as Terraform configuration

> **Note**: For production environments, we would use a remote state backends (Azure Storage, AWS S3, etc.) for better collaboration and state security.


## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Virtual Network                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                   Subnet                            │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │          Private Endpoint                   │   │   │
│  │  │     (Private IP: 10.0.0.x)                │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Private DNS Zone                          │   │
│  │    (privatelink.blob.core.windows.net)            │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ (Secure Connection)
                              │
┌─────────────────────────────────────────────────────────────┐
│                Storage Account                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Private Container                      │   │
│  │           (No Public Access)                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                              │                             │
│                              │ (Diagnostic Logs)           │
│                              ▼                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │          Monitor Diagnostic Setting                 │   │
│  │    (Logs: StorageRead, StorageWrite, etc.)        │   │
│  │    (Metrics: Transactions, Capacity, etc.)        │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ (Logs & Metrics)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Log Analytics Workspace                       │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Centralized Logging                       │   │
│  │  • Storage Account Logs (30 days retention)       │   │
│  │  • Diagnostic Metrics                             │   │
│  │  • Query and Analysis Capabilities                │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```



