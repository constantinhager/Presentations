variable "automation_account_name" {
  description = "Specifies the name of the Automation Account."
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "sku_name" {
  description = "The SKU name of the account - only Basic is supported at this time."
  default     = "Basic"
}

variable "tag_function" {
  description = "The function Tag"
}

variable "tag_creator" {
  description = "The creator Tag"
}
