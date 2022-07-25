variable "virtual_machine_id" {
  description = "The ID of the Virtual Machine to which the Data Disk should be attached."
}

variable "managed_disk_id" {
  description = "The ID of an existing Managed Disk which should be attached."
}

variable "lun" {
  description = "The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine."
}

variable "caching" {
  description = "Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite."
}
