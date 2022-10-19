variable "rg_name" {
  description = "The name of the vm resource group that can be changed through the pipeline"
}

variable "subnet_rg" {
  description = "The name of the subnet resource group that can be changed through the pipeline"
}

variable "vnet_name" {
  description = "The name of the vnet that can be changed through the pipeline"
}

variable "snet_name" {
  description = "The name of the snet that can be changed through the pipeline"
}

variable "nsg_name" {
  description = "The name of the NSG that can be changed through the pipeline"
}
