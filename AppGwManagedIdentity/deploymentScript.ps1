#*********BEGIN ASSIGN VARIABLES***********#

#Gateway Details
$gateway_resource_group = 'rg_nprd_mobile'
$identity_name = 'id-agicmobile01'
$gateway_name = 'ag-mobileac1'

$subscription_name = 'PD_com_PD'

#*********END ASSIGN VARIABLES***********#

#Set subscription
az account set --subscription $subscription_name

#Create Identity
az identity create -g $gateway_resource_group -n $identity_name
$identity_id = az identity list -g $gateway_resource_group --query "[?name=='$identity_name'].id" --output tsv

#Assing Identity to Gateway
az network application-gateway identity assign -g $gateway_resource_group --gateway-name $gateway_name --identity $identity_id