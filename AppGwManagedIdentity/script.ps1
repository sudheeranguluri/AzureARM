$resource_group = 'TestGateway'
$identity_name = 'appgw-id'
$gateway_name = 'agw-agic-aks'

#Create Identity
az identity create -g $resource_group -n $identity_name
$identity_id = az identity list -g $resource_group --query "[?name=='$identity_name'].id" --output tsv

az network application-gateway identity assign -g $resource_group --gateway-name $gateway_name --identity $identity_id