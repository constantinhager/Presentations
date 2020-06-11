az group create --name meetup-rg --location westeurope --tags creator="CH" function="TF Storage Account for State Files"

az storage account create --name meetupterraformstate --resource-group meetup-rg --location westeurope --sku Standard_LRS --kind StorageV2 --tags creator="CH" function="tfstate"

az storage container create -n compute --account-name uaiterraformstate
az storage container create -n databases --account-name uaiterraformstate
az storage container create -n managementgovernance --account-name uaiterraformstate
az storage container create -n network --account-name uaiterraformstate
az storage container create -n storage --account-name uaiterraformstate
az storage container create -n others --account-name uaiterraformstate
