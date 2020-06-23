#*********BEGIN ASSIGN VARIABLES***********#

#AKS POD Identity
$nodes_resource_group = 'rg_nprd_dev_mobile_nodes'
$pod_identity_name = 'id-podmobiledev01'

#KeyVault
$keyvault_name = 'kv-devmobile'
$keyvault_resource_group = 'rg_nprd_dev_mobile'

#Gateway
$gw_identity_name = 'id-agicmobile01'
$gw_resource_group_name = 'rg_nprd_mobile'
$gw_name = 'ag-mobileac1'

#subscription name
$subscription_name = 'PD_com_PD'

#*********END ASSIGN VARIABLES***********#


#set subscription
az account set --subscription $subscription_name
$subscription_id = az account list --query "[?name=='$subscription_name'].id" --output tsv


#Create Pod Identity
az identity create -g $nodes_resource_group -n $pod_identity_name
$pod_identity_principal_id = az identity list -g $nodes_resource_group --query "[?name=='$pod_identity_name'].principalId" --output tsv
$pod_identity_client_id = az identity list -g $nodes_resource_group --query "[?name=='$pod_identity_name'].clientId" --output tsv

#Grant Read rights for Pod Identity to KeyVault
az keyvault set-policy -n $keyvault_name -g $keyvault_resource_group --object-id $pod_identity_principal_id --secret-permissions get

#Read ID of Application Gateway
$gw_identity_id = az identity list -g $gw_resource_group_name --query "[?name=='$gw_identity_name'].id" --output tsv

#Assign Pod Identity "Managed Identity Operator" rights on Gateway Identity
az role assignment create --role "Managed Identity Operator" --assignee $pod_identity_principal_id --scope $gw_identity_id

#Assign Reader to Gateway Resource Group and Contributor to Gateway
$gateway_resource_group_id = '/subscriptions/'+$subscription_id+'/resourceGroups/'+$gw_resource_group_name
$gateway_id = '/subscriptions/'+$subscription_id+'/resourceGroups/'+$gw_resource_group_name+'/providers/Microsoft.Network/applicationGateways/'+$gw_name

az role assignment create --role Contributor --assignee $pod_identity_client_id --scope $gateway_id
az role assignment create --role Reader --assignee $pod_identity_client_id --scope $gateway_resource_group_id