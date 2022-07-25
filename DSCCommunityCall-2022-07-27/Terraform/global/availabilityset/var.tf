variable "availability_set_name" {
  description = "Specifies the name of the availability set."
}

variable "platform_domain_update_count" {
  description = "Specifies the number of update domains that are used. Defaults to 5."
  default     = 5
}

variable "platform_fault_domain_count" {
  description = "Specifies the number of fault domains that are used. Defaults to 3."
  default     = 3
}

variable "managed" {
  description = "Specifies whether the availability set is managed or not. Possible values are true (to specify aligned) or false (to specify classic). Default is true."
  default     = true
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
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
