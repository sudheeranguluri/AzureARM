#*********BEGIN ASSIGN VARIABLES***********#

#AKS Details
$cluster_name = 'pd-devmobileclstr01'
$aks_resource_group = 'rg_nprd_dev_mobile'

#ACR Details
$acr_resource_group = 'rg_nprd_dev_mobile'
$acr_name = 'acrdevmobileac1'

#subscription name
$subscription_name = 'PD_com_PD'

#*********END ASSIGN VARIABLES***********#

#set subscription
az account set --subscription $subscription_name
$subscription_id = az account list --query "[?name=='$subscription_name'].id" --output tsv


$acr_resource_id = '/subscriptions/'+$subscription_id+'/resourceGroups/'+$acr_resource_group+'/providers/Microsoft.ContainerRegistry/registries/'+$acr_name

az aks update -n $cluster_name -g $resource_group $aks_resource_group --attach-acr $acr_resource_id