variable "virtual_machine_name" {
  description = "The name of the virtual machine."
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "size" {
  description = "The size of the virtual machine."
}

variable "admin_username" {
  description = "The admin user of that virtual machine."
}

variable "admin_password" {
  description = "The admin password of that virtual machine."
}

variable "network_interface_ids" {
  description = "One or more network interface ids"
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS."
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from."
}

variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created."
}

variable "source_image_reference_publisher" {
  description = "The marketplace publisher. Default MicrosoftWindowsServer"
  default     = "MicrosoftWindowsServer"
}

variable "source_image_reference_offer" {
  description = "The marketplace offer. Default WindowsServer"
  default     = "WindowsServer"
}

variable "source_image_reference_sku" {
  description = "The marketplace sku. Default 2016-Datacenter"
  default     = "2019-Datacenter"
}

variable "source_image_reference_version" {
  description = "The marketplace version. Default latest"
  default     = "latest"
}

variable "availablility_set_id" {
  description = "Specifies the ID of the Availability Set in which the Virtual Machine should exist."
}

variable "boot_diagnostics_storage_account_uri" {
  description = "The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor. "
}

variable "identity_type" {
  description = "The type of Managed Identity which should be assigned to the Windows Virtual Machine. Possible values are SystemAssigned, UserAssigned and SystemAssigned, UserAssigned."
  default = "SystemAssigned"
}
variable "license_type" {
  description = "Specifies the type of on-premise license. Values: None, Windows_Client and Windows_Server. Default None"
  default     = "None"
}

variable "time_zone" {
  description = "Specifies the Time Zone which should be used by the Virtual Machine. Default: W. Europe Standard Time"
  default     = "W. Europe Standard Time"
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