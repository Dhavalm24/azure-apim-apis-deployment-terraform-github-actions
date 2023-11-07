variable "apim_name" {
  type        = string
  description = "(Required) The name of the API Management Service. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the API Management Service Resource. Changing this forces a new resource to be created."
}

variable "api_version_set_name" {
  type = string
  default = null
  description = "The name of the API Version Set. May only contain alphanumeric characters and dashes up to 80 characters in length. Changing this forces a new resource to be created."
}

variable "api_version_set_description" {
  type = string
  default = null
  description = "The description of API Version Set."
}

variable "api_version_set_display_name" {
  type = string
  description = "The display name of this API Version Set"
  default = null
}

variable "versioning_scheme" {
  type = string
  description = "Specifies where in an Inbound HTTP Request that the API Version should be read from. Possible values are Header, Query and Segment."
  default = null
}

variable "version_header_name" {
  type = string
  default = null
  description = "The name of the Header which should be read from Inbound Requests which defines the API Version. This must be specified when versioning_scheme is set to Header"
}

variable "version_query_name" {
  type = string
  default = null
  description = "The name of the Query String which should be read from Inbound Requests which defines the API Version. This must be specified when versioning_scheme is set to Query"
}