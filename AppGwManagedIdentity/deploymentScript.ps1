$gateway_resource_group = 'ARMTemplatesTest'
$identity_name = 'appgw-id'
$gateway_name = 'agw-agic-aks'

#Create Identity
az identity create -g $gateway_resource_group -n $identity_name
$identity_id = az identity list -g $gateway_resource_group --query "[?name=='$identity_name'].id" --output tsv

#Assing Identity to Gateway
az network application-gateway identity assign -g $gateway_resource_group --gateway-name $gateway_name --identity $identity_id