resource "azurerm_api_management_product" "product" {
  api_management_name   = var.apim_name
  resource_group_name   = var.resource_group_name
  product_id            = var.product_id
  description           = var.description
  display_name          = var.display_name
  approval_required     = var.approval_required
  published             = var.published
  subscription_required = var.subscription_required
  subscriptions_limit   = var.subscriptions_limit
}

resource "azurerm_api_management_product_policy" "main" {
  count               = var.api_product_policy == true ? 1 : 0
  product_id          = azurerm_api_management_product.product.product_id
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  xml_content         = file(var.product_xml_content)
}

# data "azurerm_api_management_group" "main" {
#   for_each            = toset(var.group_names)
#   name                = each.value
#   api_management_name = var.apim_name
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_api_management_product_group" "group" {
#   for_each            = data.azurerm_api_management_group.main
#   product_id          = azurerm_api_management_product.product.product_id
#   group_name          = data.azurerm_api_management_group.main[each.key].name
#   api_management_name = var.apim_name
#   resource_group_name = var.resource_group_name
# }

data "azurerm_api_management_group" "developers" {
  name                = "developers"
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_api_management_product_group" "developers" {
  product_id          = azurerm_api_management_product.product.product_id
  group_name          = data.azurerm_api_management_group.developers.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
}
