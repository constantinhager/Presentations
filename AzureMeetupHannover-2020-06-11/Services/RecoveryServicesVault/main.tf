module "ResourceGroup" {
  source = "../../global/ResourceGroup"

  resource_group_name = "meetupbackup-rg"
  tag_creator         = "Constantin Hager"
  tag_function        = "Resource group for Recovery Services vaults"
  location            = "West Europe"
}

module "RecoveryServicesVault" {
  source = "../../global/RecoveryServicesVault"

  resource_group_name          = module.ResourceGroup.resource_group_name
  recovery_services_vault_name = "meetupbackupvault"

  sku = "Standard"

  tag_creator  = "Constantin Hager"
  tag_function = "Recovery services Vault for hagerh"

  location = "West Europe"
}
