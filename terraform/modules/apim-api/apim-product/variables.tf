variable "apim_name" {
  type        = string
  description = "APIM name"
}
variable "resource_group_name" {
  type = string
  description = "APIM Resource group name"
}
variable "product_id" {
  type= string
  description = "(Required) The Identifier for this Product, which must be unique within the API Management Service. Changing this forces a new resource to be created."
}
variable "description" {
  type = string
  description = " (Optional) A description of this Product, which may include HTML formatting tags."
}
variable "display_name" {
  type = string
  description = "(Required) The Display Name for this API Management Product."
}
variable "approval_required" {
  type = bool
  description = "(Optional) Do subscribers need to be approved prior to being able to use the Product? approval_required can only be set when subscription_required is set to true."
  default = false
}
variable "subscription_required" {
  type = bool
  description = "(Optional) In AIS a Subscription required is always set to True."
  default = true
}
variable "subscriptions_limit" {
  type = string
  description = "(Optional) The number of subscriptions a user can have to this Product at the same time. subscriptions_limit can only be set when subscription_required is set to true."
  default = null
}
variable "published" {
  type = bool
  default=true
  description = "(Optional) Is this Product Published? Dafaults to true"
}

variable "api_product_policy" {
  type = bool
  default = false
}

variable "product_xml_content" {
  type = string
  default = null
}

variable "group_names" {
  type    = list(string)
  default = ["administrators", "developers"]
}