variable "virtual_network_name" {
    description = "The name of the virtual network"
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "address_space" {
    description = "The addressspace of the VNet"
}

variable "dns_servers" {
    description = "The DNS Servers in the VNet"
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
