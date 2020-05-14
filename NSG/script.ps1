$resourceGroup = 'ARMTemplatesTest'
$nsg_Name = 'nsg-agw-apim'
$subnet_Name = 'snet_pd_pd_nprd_mobile_agic_ac1'
$vnet_name = 'vnet_pd_pd_mobile_ac1'

$Block_80_8080_443_Rule = "Block_80_8080_443"
$APIM_443 = 'APIM_443'
$Allow_Azure_Ports = 'Allow_Azure_Ports'
$APIM_PIP = "40.117.237.73"


az network nsg create -g $resourceGroup -n $nsg_Name --tags Agency="PDOT" Division="Mobile" Region="non-prd" Environment="PD" Application="Network Security Group"

az network nsg rule create -g $resourceGroup --nsg-name $nsg_Name -n $Block_80_8080_443_Rule --priority 110 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes '*' --destination-port-ranges 80 8080 443 --access Deny --protocol * --description "Deny from specific IP address ranges on 80, 8080 and 443"

az network nsg rule create -g $resourceGroup --nsg-name $nsg_Name -n $APIM_443 --priority 105 --source-address-prefixes $APIM_PIP --source-port-ranges * --destination-address-prefixes '172.16.3.0/28' --destination-port-ranges 443 --access Allow --protocol * --description "Allow only 443 traffic from APIM"

az network nsg rule create -g $resourceGroup --nsg-name $nsg_Name -n $Allow_Azure_Ports --priority 102 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes '*' --destination-port-ranges 65200-65535 --access Allow --protocol * --description "Allow Azure Ports"

az network vnet subnet update -g $resourceGroup -n $subnet_Name --vnet-name $vnet_name --network-security-group $nsg_Name