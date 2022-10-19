variable "storage_account_name" {
  description = "Name of storage account"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account"
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account."
}

variable "access_tier" {
  description = "Defines the access tier (Hot, Cool)"
  default     = "Hot"
}

variable "account_kind" {
  description = "Defines the Kind of account. (BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2)"
  default     = "StorageV2"
}

variable "versioning_enabled" {
  description = "Is versioning enabled? Default to false."
  default     = false
}

variable "tag_function" {
  description = "Function of the resource e.g.: Active Directory Domain Controller"
}

variable "tag_application" {
  description = "Name of the application e.g.: DNS"
}

variable "tag_applicationowner" {
  description = "Responsible person of the application"
}

variable "tag_department" {
  description = "Name of the department where the VM is mainly used"
}

variable "tag_location" {
  description = "Name of the main location usage e.g.: Hungary, Germany, All"
}
