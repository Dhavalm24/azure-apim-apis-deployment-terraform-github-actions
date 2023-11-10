# Azure API Deployment with Terraform using GitHub Actions

## Overview

This repository contains the necessary files and configurations to deploy an API on Azure using Terraform. The deployment process is automated using GitHub Actions, ensuring a smooth and consistent deployment pipeline.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Folder Structure](#folder-structure)
- [Setup](#setup)
- [Workflow](#workflow)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, make sure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Architecture
![Architecture](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/architecture/architecture.png)

## Folder Structure
```
.
├── .github/workflows           # GitHub Actions workflows
│   └── main.yml                # Main workflow for deployment
├── infra                       # Terraform infrastructure code
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variables used in the configuration
│   └── outputs.tf              # Output values from the configuration
├── src                         # Source code for the API
│   └── app                     # API application code
├── README.md                   # Project documentation
└── LICENSE                     # License information
```
## Setup

### 1. Clone this repository:

```bash
git clone https://github.com/{your-username}/azure-apim-apis-deployment-terraform-github-actions
cd azure-apim-apis-deployment-terraform-github-actions
```

### 2. Create a service principal in Azure and set the following secrets in your GitHub repository settings:

- `ARM_CLIENT_ID`: Azure Service Principal Client ID
- `ARM_CLIENT_SECRET`: Azure Service Principal Client Secret
- `ARM_SUBSCRIPTION_ID`: Azure Subscription ID
- `ARM_TENANT_ID`: Azure Tenant ID

### 3. Customize the Terraform configuration in the `infra` folder according to your requirements.

### 4. Workflow.

| Column 1 Header | Column 2 Header | Column 3 Header |
|-----------------|-----------------|-----------------|
| Row 1, Col 1    | Row 1, Col 2    | **Row** 1, Col 3    |
| Row 2, Col 1    | Row 2, Col 2    | Row 2, Col 3    |
| Row 3, Col 1    | Row 3, Col 2    | Row 3, Col 3    |
| Row 4, Col 1    | Row 4, Col 2    | Row 4, Col 3 this is test    |


The GitHub Actions workflow is defined in .github/workflows/main.yml. It performs the following steps:

Set up the environment with necessary tools (Terraform, Azure CLI).
Authenticate with Azure using the service principal.
Run Terraform commands to plan and apply the infrastructure changes.
The workflow is triggered on every push to the main branch.

Contributing
Feel free to contribute to this project by opening issues or creating pull requests. Your feedback and contributions are highly appreciated.

License
This project is licensed under the MIT License.
