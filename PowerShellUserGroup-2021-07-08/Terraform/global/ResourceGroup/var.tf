variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "location" {
  description = "The Azure Location where you want to deploy to"
  default     = "West Europe"
}

variable "tag_function" {
  description = "The function Tag"
}

variable "tag_creator" {
  description = "The creator Tag"
}
