az group create --name meetup-rg --location westeurope --tags creator="Constantin Hager" function="Meetup TF Storage Account for State Files"

az storage account create --name meetupterraformstate --resource-group meetup-rg --location westeurope --sku Standard_LRS --kind StorageV2 --tags creator="Constantin Hager" function="tfstate"

az storage container create -n compute --account-name meetupterraformstate
az storage container create -n databases --account-name meetupterraformstate
az storage container create -n managementgovernance --account-name meetupterraformstate
az storage container create -n network --account-name meetupterraformstate
az storage container create -n storage --account-name meetupterraformstate
az storage container create -n others --account-name meetupterraformstate
