variable "rg_name" {
  description = "The name of the vm resource group that can be changed through the pipeline"
}

variable "subnet_rg" {
  description = "The name of the subnet resource group that can be changed through the pipeline"
}

variable "aadsc_rg" {
  description = "The name of the Azure Automation Account resource group that can be changed through the pipeline"
}

variable "aadsc_name" {
  description = "The name of the Azure Automation Account that can be changed through the pipeline"
}

