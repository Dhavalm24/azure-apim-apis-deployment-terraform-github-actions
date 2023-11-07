# # output "id" {
# #   value = azurerm_api_management_api.api[*].id
# #   description = "The ID of the API Management service"
# # }

# output "api_names" {
# value = [for api in var.apis : api.api_name]
# }

# output "api_display_names" {
# value = [for api in var.apis : api.api_display_name]
# }

# output "api_paths" {
# value = [for api in var.apis : api.api_path]
# }

# output "api_service_urls" {
# value = [for api in var.apis : api.api_service_url]
# }

# output "subscription_requirements" {
# value = [for api in var.apis : api.subscription_required]
# }

# # output "product_ids" {
# # value = [for api in var.apis : api.product_id]
# # }



# # output "bd_name" {
# #   value = toset([
# #     for bd in mso_schema_template_bd.bd : bd.name
# #   ])
# # }

# # output "api_name" {
# #   value = {
# #     for api in azurerm_api_management_api.api: api.value.api_name => api.value.api_name
# #   }
# # }

# # output "api_display_name" {
# #   value = {
# #     for api in azurerm_api_management_api.api: api.value.api_name => api.value.display_name
# #   }
# # }

# # output "api_path" {
# #   value = {
# #     for api in azurerm_api_management_api.api: api.value.api_name => api.value.api_path
# #   }
# # }


# # output "api_service_url" {
# #   value = {
# #     for api in azurerm_api_management_api.api: api.value.api_name => api.value.service_url
# #   }
# # }

