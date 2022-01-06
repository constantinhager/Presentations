variable "private_network_interface_name" {
  description = "The name of the private interface."
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "enable_ip_forwarding" {
  description = "Should IP Forwarding be enabled? Defaults to false."
  default     = false
  type        = bool
}

variable "enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to false."
  default     = false
  type        = bool
}

variable "ip_configuration_name" {
  description = "A name used for this IP Configuration."
}

variable "ip_configuration_subnet_id" {
  description = "The ID of the Subnet where this Network Interface should be located in."
}

variable "ip_configuration_private_ip_address_allocation" {
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
  default     = "Static"
}

variable "ip_configuration_primary" {
  description = "Is this the Primary IP Configuration? Must be true for the first ip_configuration when multiple are specified. Defaults to false."
  default     = true
  type        = bool
}

variable "ip_configuration_private_ip_address" {
  description = "The Static IP Address which should be used."
}

variable "ip_configuration_public_ip_address_id" {
  description = "The Static IP Address which should be used."
}

variable "ip_configuration_private_ip_address_version" {
  description = "The IP Version to use. Possible values are IPv4 or IPv6. Defaults to IPv4."
  default     = "IPv4"
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
