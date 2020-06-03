module "ResourceGroup" {
  source = "../../../Global/ResourceGroup"

  resource_group_name = "backup-rg"
  tag_creator         = "Constantin Hager"
  tag_function        = "Resource group for Recovery Services vaults"
  location            = "North Europe"
}

module "RecoveryServicesVault" {
  source = "../../../Global/RecoveryServicesVault"

  resource_group_name          = module.ResourceGroup.resource_group_name
  recovery_services_vault_name = "uaibackup01"

  sku = "Standard"

  tag_creator  = "Constantin Hager"
  tag_function = "Recovery services Vault for UAI"

  location = "North Europe"
}
