variable "string_variable_name" {
  description = "The name of the Automation Variable."
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Automation Variable."
}

variable "automation_account_name" {
  description = "The name of the automation account in which the Variable is created."
}

variable "description" {
  description = "The description of the Automation Variable."
}

variable "encrypted" {
  description = "Specifies if the Automation Variable is encrypted. Defaults to false."
  default     = false
}

variable "value" {
  description = "The value of the Automation Variable as a string."
}
