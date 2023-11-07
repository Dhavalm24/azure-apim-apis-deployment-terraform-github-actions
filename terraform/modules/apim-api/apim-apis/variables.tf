
variable "apim_name" {
  type        = string
  description = "(Required) The name of the API Management Service. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the API Management Service Resource. Changing this forces a new resource to be created."
}

variable "api_name" {
  type = string
}
variable "api_display_name" {
  type = string
}
variable "api_description" {
  type = string
  default = null
}
variable "api_path" {
  type = string
}

variable "api_service_url" {
  type    = string
  default = null
}
variable "subscription_required" {
  type    = bool
  default = true
}
variable "revision" {
  type = string
}
variable "product_id" {
  type = set(string)
}

variable "api-operations" {
  type = list(object({
    api_operation_name        = string,
    api_operation_displayname = string,
    api_operation_method      = string,
    api_operation_url         = string,
    api_operation_description = string,
    template_parameter = list(object({
      name        = string
      description = string
      type        = string
      required    = bool
      values      = list(string)
    })),
    response = list(object({
      status_code = number
      description = string
      representation = list(object({
        content_type = string
        type_name    = string
        schema_id    = string
        example = list(object({
          name        = string
          description = string
          value       = string
        }))
      }))
      header = list(object({
        name        = string
        description = string
        type        = string
        values      = list(string)
        required    = bool
      }))
    })),
    request = list(object({
      description = string
      representation = list(object({
        content_type = string
        type_name    = string
        schema_id    = string
        example = list(object({
          name        = string
          description = string
          value       = string
        }))
      }))
      query_parameter = list(object({
        name          = string
        required      = bool
        type          = string
        description   = string
        default_value = string
        values        = list(string)
      }))
    })),
  }))
  default = []
}

variable "operation-policies" {
  type = list(object({
    operation_id          = string,
    operation_xml_content = string
  }))
  default = []
}

variable "api_policy" {
  type    = bool
  default = false
}

variable "api_xml_content" {
  type    = string
  default = null
}

variable "apim_policy" {
  type    = bool
  default = false
}

variable "apim_policy_fragment" {
  type = list(object({
    name        = string,
    apim_policy = string
  }))
  default = []
}

variable "named_value" {
  type = list(object({
    name                 = string,
    display_name         = string,
    value                = string,
    secret               = bool,
    value_from_key_vault = list(object({
        secret_id          = string
      }))
  }))
  default = []
}

variable "api-schema" {
  type = list(object({
    api_schema_id       = string,
    schema_content_type = string,
    schema_value        = string,
    schema_definitions  = string
  }))
  default = []
}

variable "enable_api_version" {
  type        = bool
  default     = false
  description = "Enable API version? Set to true to enable API version"
}

variable "api_version" {
  type        = string
  default     = null
  description = "The Version number of this API, if this API is versioned."
}

variable "api_version_set_id" {
  type        = string
  default     = null
  description = "Version set ID"
}

variable "api_operation_tag" {
  type = list(object({
    index        = number,
    operation_id = string,
    name         = string,
    display_name = string
  }))
  default = []
}

variable "api_tag" {
  type = list(object({
    index        = number,
    name         = string
  }))
  default = []
}

variable "api_import" {
  type = set(object(
    {
      content_format     = string
      content_value = string
    }
  ))
  default = []
}

variable "api_type" {
  type = string
  default = "http"
  description = "(Optional) Type of API. Possible values are graphql, http, soap, and websocket. Defaults to http"
}