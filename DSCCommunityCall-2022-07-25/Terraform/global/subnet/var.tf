variable "subnet_name" {
  description = "The name of the subnet"
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
}

variable "address_prefixes" {
  description = "The address prefixes to use for the subnet."
  type = list(string)
}
