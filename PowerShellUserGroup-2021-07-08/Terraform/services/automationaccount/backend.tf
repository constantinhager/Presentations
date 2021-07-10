terraform {
  backend "azurerm" {

    resource_group_name  = "tfstate-rg"
    storage_account_name = "chterraformbestpractices"
    container_name       = "tfstate"
    key                  = "automation.tfstate"
    client_id            = "652308bc-72f7-4c7e-b089-c21c3e5d694c"
    client_secret        = "Pd4S.Ac5hSt1yeI3uZ_hf.J91w63L.45-z"
    subscription_id      = "3932848d-e8f8-4a6e-a772-bc69214d0530"
    tenant_id            = "f8ddd457-53bf-4bcd-bd31-c1a30d7c78d7"
  }
}
