resource "azurerm_api_management_api_version_set" "api_version_set" {
  name                = var.api_version_set_name
  description         = var.api_version_set_description
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  display_name        = var.api_version_set_display_name
  versioning_scheme   = var.versioning_scheme
  version_header_name = var.versioning_scheme == "Header" ? var.version_header_name : null
  version_query_name  = var.versioning_scheme == "Query" ? var.version_query_name : null
}
