variable "managed_disk_name" {
  description = "Specifies the name of the Managed Disk."
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "storage_account_type" {
  description = "The type of storage to use for the managed disk. Possible values are Standard_LRS, Premium_LRS, StandardSSD_LRS or UltraSSD_LRS."
}

variable "disk_size_gb" {
  description = "Specifies the size of the managed disk to create in gigabytes."
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