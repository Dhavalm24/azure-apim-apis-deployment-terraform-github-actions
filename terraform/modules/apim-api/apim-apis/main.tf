data "azurerm_api_management" "main" {
  name                = var.apim_name
  resource_group_name = var.resource_group_name
}
resource "azurerm_api_management_api" "api" {
  api_management_name   = var.apim_name
  display_name          = var.api_display_name
  description           = var.api_description
  name                  = var.api_name
  path                  = var.api_path
  service_url           = var.api_service_url
  protocols             = ["https"]
  resource_group_name   = var.resource_group_name
  revision              = var.revision
  subscription_required = var.subscription_required
  subscription_key_parameter_names {
    header = "Ocp-Apim-Subscription-Key"
    query  = "subscription-key"
  }
  api_type = var.api_type
  dynamic "import" {
    for_each = var.api_import
    content {
      content_format = import.value["content_format"]
      content_value  = import.value["content_value"]
    }
  }
  version        = var.enable_api_version == true ? var.api_version : null
  version_set_id = var.enable_api_version == true ? var.api_version_set_id : null
}

resource "azurerm_api_management_product_api" "product_api" {
  for_each            = toset(var.product_id)
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  api_name            = azurerm_api_management_api.api.name
  product_id          = each.value
}

resource "azurerm_api_management_api_operation" "operations" {
  for_each            = { for operation in var.api-operations : operation.api_operation_name => operation }
  api_name            = azurerm_api_management_api.api.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  operation_id        = each.value.api_operation_name
  display_name        = each.value.api_operation_displayname
  method              = each.value.api_operation_method
  url_template        = each.value.api_operation_url
  description         = each.value.api_operation_description


  dynamic "template_parameter" {
    for_each = each.value.template_parameter
    content {
      name        = template_parameter.value.name
      description = template_parameter.value.description
      type        = template_parameter.value.type
      required    = template_parameter.value.required
      values      = template_parameter.value.values
    }
  }

  dynamic "request" {
    for_each = each.value.request
    content {
      description = request.value.description
      dynamic "query_parameter" {
        for_each = try(request.value.query_parameter, [])
        content {
          name          = query_parameter.value.name
          required      = query_parameter.value.required
          type          = query_parameter.value.type
          description   = query_parameter.value.description
          default_value = query_parameter.value.default_value
          values        = query_parameter.value.values
        }
      }
      dynamic "representation" {
        for_each = try(request.value.representation, [])
        content {
          content_type = representation.value.content_type
          type_name    = representation.value.type_name
          schema_id    = representation.value.schema_id
          dynamic "example" {
            for_each = try(representation.value.example)
            content {
              name        = example.value.name
              description = example.value.description
              value       = example.value.value
            }
          }
        }
      }
    }
  }

  dynamic "response" {
    for_each = each.value.response
    content {
      status_code = response.value.status_code
      description = response.value.description
      dynamic "representation" {
        for_each = try(response.value.representation, [])
        content {
          content_type = representation.value.content_type
          type_name    = representation.value.type_name
          schema_id    = representation.value.schema_id
          dynamic "example" {
            for_each = try(representation.value.example)
            content {
              name        = example.value.name
              description = example.value.description
              value       = example.value.value
            }
          }
        }
      }
      dynamic "header" {
        for_each = try(response.value.header, [])
        content {
          name        = header.value.name
          description = header.value.description
          type        = header.value.type
          values      = header.value.values
          required    = header.value.required
        }
      }
    }
  }
}

resource "azurerm_api_management_api_operation_policy" "policies" {
  for_each = { for policy in var.operation-policies : policy.operation_id => policy }

  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  api_name            = azurerm_api_management_api.api.name
  operation_id        = azurerm_api_management_api_operation.operations[each.value.operation_id].operation_id
  xml_content         = file(each.value.operation_xml_content)
  depends_on          = [azurerm_api_management_named_value.main]
}

resource "azurerm_api_management_api_policy" "main" {
  count               = var.api_policy == true ? 1 : 0
  api_name            = azurerm_api_management_api.api.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  xml_content         = file(var.api_xml_content)
}

resource "azurerm_api_management_named_value" "main" {
  for_each            = { for named_value in var.named_value : named_value.name => named_value }
  resource_group_name = var.resource_group_name
  api_management_name = var.apim_name
  name                = each.value.name
  display_name        = each.value.display_name
  value               = each.value.value
  secret              = each.value.secret
  dynamic "value_from_key_vault" {
    for_each = each.value.value_from_key_vault != null ? each.value.value_from_key_vault : []
    content {
      secret_id = value_from_key_vault.value.secret_id
    }
  }
}

resource "azapi_resource" "apim_policy_fragment" {
  for_each  = { for apim_policy_fragment in var.apim_policy_fragment : apim_policy_fragment.name => apim_policy_fragment }
  type      = "Microsoft.ApiManagement/service/policyFragments@2021-12-01-preview"
  name      = each.value.name
  parent_id = data.azurerm_api_management.main.id

  body = jsonencode({
    properties = {
      format = "xml"
      value  = file(each.value.apim_policy)
    }
  })
}

resource "azurerm_api_management_api_schema" "schema" {
  for_each            = { for schema in var.api-schema : schema.api_schema_id => schema }
  api_name            = azurerm_api_management_api.api.name
  api_management_name = var.apim_name
  resource_group_name = var.resource_group_name
  schema_id           = each.value.api_schema_id
  content_type        = each.value.schema_content_type
  value               = each.value.schema_value
  definitions         = each.value.schema_definitions
}

resource "azurerm_api_management_api_operation_tag" "api_operation_tag" {
  for_each         = { for api_operation_tag in var.api_operation_tag : api_operation_tag.index => api_operation_tag }
  name             = each.value.name
  api_operation_id = azurerm_api_management_api_operation.operations[each.value.operation_id].id
  display_name     = each.value.display_name
}
## Developers Should be able to create new tag at API level?

resource "azurerm_api_management_api_tag" "api_tag" {
  for_each = { for api_tag in var.api_tag : api_tag.index => api_tag }
  api_id   = azurerm_api_management_api.api.id
  name     = each.value.name
}
