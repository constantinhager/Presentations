az group create --name tfstate-rg --location northeurope --tags creator="CH" function="TF RG"

az storage account create --name uaiterraformstate --resource-group tfstate-rg --location northeurope --sku Standard_LRS --kind StorageV2 --tags creator="CH" function="tfstate"

az storage container create -n compute --account-name uaiterraformstate
az storage container create -n databases --account-name uaiterraformstate
az storage container create -n managementgovernance --account-name uaiterraformstate
az storage container create -n network --account-name uaiterraformstate
az storage container create -n storage --account-name uaiterraformstate
az storage container create -n others --account-name uaiterraformstate