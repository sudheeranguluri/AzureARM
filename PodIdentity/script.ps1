$nodes_resource_group = 'AKS01-nodes'
$pod_identity_name = 'podIdentity'

#Create Pod Identity
az identity create -g $nodes_resource_group -n $pod_identity_name
$pod_identity_principal_id = az identity list -g $nodes_resource_group --query "[?name=='$pod_identity_name'].principalId" --output tsv
$pod_identity_client_id = az identity list -g $nodes_resource_group --query "[?name=='$pod_identity_name'].clientId" --output tsv

#Grant Read rights for Pod Identity to KeyVault
$keyvault_name = 'kv-mobile-nprd'
$keyvault_resource_group = 'ARMTemplatesTest'

az keyvault set-policy -n $keyvault_name -g $keyvault_resource_group --object-id $pod_identity_principal_id --secret-permissions get

#Read ID of Application Gateway
$gw_identity_name = 'appgw_id'
$gw_identity_resource_group = 'ARMTemplatesTest'
$gw_identity_id = az identity list -g $gw_identity_resource_group --query "[?name=='$gw_identity_name'].id" --output tsv

#Assign Pod Identity "Managed Identity Operator" rights on Gateway Identity
az role assignment create --role "Managed Identity Operator" --assignee $pod_identity_principal_id --scope $gw_identity_id

#Assign Reader to Gateway Resource Group and Contributor to Gateway
$gateway_resource_group_id = '/subscriptions/d7713b76-bdce-4b8a-bda2-987e866c6bb7/resourceGroups/ARMTemplatesTest'
$gateway_id = '/subscriptions/d7713b76-bdce-4b8a-bda2-987e866c6bb7/resourceGroups/ARMTemplatesTest/providers/Microsoft.Network/applicationGateways/agw-agic-aks'

az role assignment create --role Contributor --assignee $pod_identity_client_id --scope $gateway_id
az role assignment create --role Reader --assignee $pod_identity_client_id --scope $gateway_resource_group_id