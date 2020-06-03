variable "recovery_services_vault_name" {
  description = "Specifies the name of the Recovery Services Vault."
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "sku" {
  description = "Sets the vault's SKU. Possible values include: Standard, RS0."
}

variable "soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to true."
  default     = true
}

variable "tag_function" {
  description = "The function Tag"
}

variable "tag_creator" {
  description = "The creator Tag"
}
