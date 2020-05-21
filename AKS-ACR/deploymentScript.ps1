#*********BEGIN ASSIGN VARIABLES***********#

#AKS Details
$cluster_name = 'AKS01'
$aks_resource_group = 'ARMTemplatesTest'

#ACR Details
$acr_resource_group = 'ARMTemplatesTest'
$acr_name = 'acrmobileprd'

#subscription name
$subscription_name = 'PD-DEV'

#*********END ASSIGN VARIABLES***********#

#set subscription
az account set --subscription $subscription_name
$subscription_id = az account list --query "[?name=='$subscription_name'].id" --output tsv


$acr_resource_id = '/subscriptions/'+$subscription_id+'/resourceGroups/'+$acr_resource_group+'/providers/Microsoft.ContainerRegistry/registries/'+$acr_name

az aks update -n $cluster_name -g $resource_group $aks_resource_group --attach-acr $acr_resource_id