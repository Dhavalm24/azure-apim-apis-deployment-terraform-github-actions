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
![architecture](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/assets/74292754/96f9c416-b6d5-40d0-a173-7ad0d7f9dcf2)


## Folder Structure
```
.
├── .github/workflows                         # GitHub Actions workflows
│   ├── deploy.apiconnection.azblob.yml       # Workflow for BLOB Connection Deployment in Logic App
│   ├── deploy.azfunctionapp.yml              # Workflow for Function App Deployment
│   ├── deploy.azlogicapp.yml                 # Workflow for Logic App Deployment 
│   ├── deploy.Create_API_Sub.yml             # Workflow for Creating Subscription in Azure API Management Service and Storing Keys in Key Vault
│   ├── deploy.function_withAPI.yml           # Workflow for .net function deployment in Azure Function App and creating named value pair and Backend in Azure API Managent Service
│   ├── deploy.function.yml                   # Workflow for .net function deployment in Azure Function App
│   ├── deploy.workflow_withAPI.yml           # Workflow for Logic App workflow deployment in Azure Logic App and creating named value pair and Backend in Azure API Managent Service 
│   ├── deploy.workflow.yml                   # Workflow for Logic App workflow deployment in Azure Logic App
│   ├── terraformApply.yml                    # Workflow for applying the API deployment in Azure API Management service
│   ├── terraformPlan.yml                     # Workflow to view the plan for API deployment in Azure API Management service
│   └── UpdateLAParameter.yml                 # Workflow for deploying the Parameters for Logic App workflow
├── apps                                      # Place the Logic App Workflows inside this folder
│   └── hello                                 # Reference Logic App Workflow code
├── deployments                               # Logic App, Function App and Connection ARM Templates Folder
|   └── azblob                                # Pace all the BLOB Connection inside this Folder
|       └── API-PROJECT-NAME                  # BLOB Connection Folder - (Replace the Folder Name as per requirement)
|           ├── parameters.DEV.json           # Parametes file for Blob connection creation (This is for one environment -DEV, copy the same file and rename DEV to another enviroment eg. UAT/PROD to create BLOB connection in UAT/PROD environment.
|           └── template.json                 # Template file for BLOB Connection
|   └── azfunctionapp                         # Place all the Function Apps inside this Folder
|       └── FA-PROJECT-NAME                   # Function App Folder - (Replace the Folder Name as per requirement)
|           ├── parameters.DEV.json           # Parametes file for Function App creation (This is for one environment -DEV, copy the same file and rename DEV to another enviroment eg. UAT/PROD to create Function Apps in UAT/PROD environment). 
|           └── template.json                 # Template file for Function App
|   └── azlogicapp                            # Place all the Logic Apps inside this Folder
|       └── LA-PROJECT-NAME                   # Function App Folder - (Replace the Folder Name as per requirement)
|           ├── parameters.DEV.json           # Parametes file for Logic App creation (This is for one environment -DEV, copy the same file and rename DEV to another enviroment eg. UAT/PROD to create Logic Apps in UAT/PROD environment).
|           └── template.json                 # Template file for Logic App
├── functions                                 # Place the Functions inside this folder
│   └── Greetings                             # Reference .net Function code
├── terraform                                 # Terraform configuration folder
│   └── Dev                                   # Environment Folder. (This is for one environment -DEV, copy the folder and rename DEV to another environment eg. UAT/PROD to create
|        └── api-import                       # Place the .json, wsdl files in this folder for importing the API
|        └── api-operation-policy             # Place the API Operation Policies inside this folder
|        └── api-policy                       # Place the API Policy inside this folder
|        └── api-product-policy               # Place the API Product Policy inside this folder
|        └── api-schema                       # Place the API schemas inside this folder
|        └── apim-policy                      # Place the APIM Policy inside this folder
|        ├── env.tfvars                       # Environmental Variables file
|        ├── main.tf                          # Terraform configuration file for creating API, API Operation, Product, API tags, API Operation Tags, API Operation Request and reponse header, importing an API.
|        └── variables.tf                     # Variables file         

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
