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
|        ├── main.tf                          # Terraform configuration file for creating API, API Operation, API Version Set, API Product, API tags, API Operation Tags, API Operation Request and reponse header, importing an API.
|        └── variables.tf                     # Variables file         
|   └── modules                               # Terraform configuration modules
|        └── apim-api
|            └── apim-api-version-set        # API Version Set module
|            └── apim-apis                   # API Creation module
|            └── apim-product                # API Product creation module
|   ├── backend.tf                           # Terraform Backend configuration for state storage
|   └── providers.tf                         # Terraform provide configuration           
├── README.md                                # Project documentation
└── LICENSE                                  # License information
```
## Setup

### 1. Clone this repository:

```bash
git clone https://github.com/{your-username}/azure-apim-apis-deployment-terraform-github-actions
cd azure-apim-apis-deployment-terraform-github-actions
```

### 2. Create a service principal in Azure and set the following secrets in your GitHub repository settings:
**Create GitHub Environment:**
The workflows utilizes GitHub Environments and Secrets to store the azure identity information. Create an environment named `Dev` by following these [instructions](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment#environment-secrets)
.
- `ARM_CLIENT_ID`: Azure Service Principal Client ID
- `ARM_SUBSCRIPTION_ID`: Azure Subscription ID
- `ARM_TENANT_ID`: Azure Tenant ID
- `PEM-PWD`: Azure Service Principal Certificate PFX
- `TF_BACKEND_RG`: Terraform State Storage Account Resource Group
- `TF_BACKEND_STACC`: Terraform State Storage Account Name
- `TF_CONTAINER`: Terraform State Storage Container
- `ARM_CLIENT_CERTIFICATE`: Azure Service Principal Certificate PFX
- `ARM_CERT_THUMBPRINT`: Azure Service Principal Certificate Thumbprint
- `ARM_KEYVAULT`: Azure Key Vault
- `RUNNER_USER`: Github Self Hosted Runner User Name

  Create Below variables
- `APIM_NAME`: Azure API Management Service Name
- `APIM_RG`: Azure API Management Service Resource Group
  
### 3. Getting Started

1. Create a Service principal in Azure and use certificate based authentication to authenticate in Azure. For [reference](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-3)
2. Create a Self-Hosted Runner for Logic App Workflows and Function App Functions deployment. For [reference](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners/about-self-hosted-runners)
3. Managed Github runner to be used for Terraform deployment. For [reference](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners)
4. Key Vault needs to be created before starting the deployment as the Key vault referenced is used in multiple github action workflows.
5. Azure API Management Service managed identity needs to be provided with Get, List secret permission in the access policies for the Key Vault.
6. Azure Service Princpal needs to be provided with Get, List, Set permission in the access policies for the Key vault.
7. Storage account needs to be created for Terraform state storage.

### 4. Deployment Steps
The Approach for publishing the Logic App APIs in APIM would be as follows:- 

1. Place the Application in the apps/folder
2. Go to deployments/azlogicapp -Update Parameters.{env}.json file
3. Update the Policy, add the APIs, API's Operations and map the operation’s Policy, add Product and update the Product's Policy (optional), add Operations Tags (optional), request and response header (optional), API version Set (optional), api-schemas (optional) in the terraform/{env}/main.tf
4. User would need to update/replace the Backend Name, Workflow Name in the API Operation Policy for the respective environment (Dev, UAT, PRD) and create an operation policy for each Logic App workflow in Terraform.
5. Push the changes to the repository
6. Run the Deploy Logic App pipeline - ([deployazlogicapp.yml](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/.github/workflows/deploy.azlogicapp.yml)). This Step can be skipped if the Logic App is already present in Azure.
7. Run the Deploy Logic App Workflow with API pipeline. ([deploy.workflow_withAPI.yml](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/.github/workflows/deploy.workflow_withAPI.yml)) This will create a Backend, Named Value Pair in Azure API Management.
8. Run Terraform Plan
9. Run Terraform Apply

The Approach for publishing the Function App APIs in APIM would be as follows: -

1. Place the Application in the functions/folder
2. Go to deployments/azfunctionapp -Update Parameters.{env}.json file
3. Update the Policy, add the APIs, API's Operations and map the operation’s Policy, add Product and update the Product's Policy (optional), add Operations Tags (optional), request and response header (optional), API version Set (optional), api-schemas (optional) in the terraform/{env}/main.tf
4. User would need to update/replace the Backend Name, Workflow Name in the API Operation Policy for the respective environment (Dev, UAT, PRD) and create an operation policy for each Function in Terraform.
5. Push the changes to the repository
6. Run the Deploy Function App pipeline - ([deployazfunctionapp.yml](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/.github/workflows/deploy.azfunctionapp.yml)). This Step can be skipped if the Function App is already present in Azure.
7. Run the Deploy Function App Workflow with API pipeline. ([deploy.function_withAPI.yml](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/.github/workflows/deploy.function_withAPI.yml))This will create a Backend, Named Value Pair in Azure API Management.
8. Run Terraform Plan
9. Run Terraform Apply

### 5. Workflows

1. ([deploy.apiconnection.azblob.yml](https://github.com/Dhavalm24/azure-apim-apis-deployment-terraform-github-actions/blob/main/.github/workflows/deploy.apiconnection.azblob.yml)

| Column 1 Header | Column 2 Header | Column 3 Header |
|-----------------|-----------------|-----------------|
| Row 1, Col 1    | Row 1, Col 2    | **Row** 1, Col 3    |
| Row 2, Col 1    | Row 2, Col 2    | Row 2, Col 3    |
| Row 3, Col 1    | Row 3, Col 2    | Row 3, Col 3    |
| Row 4, Col 1    | Row 4, Col 2    | Row 4, Col 3 this is test    |



### 6. Contributing
Feel free to contribute to this project by opening issues or creating pull requests. Your feedback and contributions are highly appreciated.

### 7. License
This project is licensed under the MIT License.
