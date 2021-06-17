variable "automation_credential_name" {
  description = "Specifies the name of the Credential."
}

variable "resource_group_name" {
  description = "The name of the resourcegroup"
}

variable "automation_account_name" {
  description = "The name of the automation account in which the Credential is created."
}

variable "username" {
  description = "The username associated with this Automation Credential."
}

variable "password" {
  description = "The password associated with this Automation Credential."
}

variable "description" {
  description = "The description associated with this Automation Credential."
}
