$networkResourceGroup = 'ARMTemplatesTest'
$nsg_Name = 'nsg-agw-apim'
$subnet_Name = 'snet_pd_pd_nprd_mobile_agic_ac1'
$vnet_name = 'vnet_pd_pd_mobile_ac1'

$Block_80_8080_443_Rule = "Block_80_8080_443"
$Allow_Azure_Ports = 'Allow_Azure_Ports'

$APIM_443 = 'APIM_443'
$APIM_Name='apim-mobile'
$APIM_Resource_Group='ARMTemplatesTest'



#Create NSG
az network nsg create -g $networkResourceGroup -n $nsg_Name --tags Agency="PDOT" Division="Mobile" Region="non-prd" Environment="PD" Application="Network Security Group"

#Block public traffic
az network nsg rule create -g $networkResourceGroup --nsg-name $nsg_Name -n $Block_80_8080_443_Rule --priority 110 --source-address-prefixes * --source-port-ranges * `
--destination-address-prefixes '*' --destination-port-ranges 80 8080 443 --access Deny --protocol * --description "Deny from specific IP address ranges on 80, 8080 and 443"

#Allow APIM ingress
#Get APIM public ip address
$apim_public_ip_address = az apim show --resource-group $APIM_Resource_Group --name $APIM_Name --query "publicIpAddresses[0]" --output tsv

#Get Subnet CIDR
$subnet_cidr = az network vnet subnet show --resource-group $networkResourceGroup --vnet-name $vnet_name --name $subnet_Name --query "addressPrefix" --output tsv

az network nsg rule create -g $networkResourceGroup --nsg-name $nsg_Name -n $APIM_443 --priority 105 --source-address-prefixes $apim_public_ip_address `
    --source-port-ranges * --destination-address-prefixes $subnet_cidr --destination-port-ranges 443 --access Allow --protocol * --description "Allow only 443 traffic from APIM"

#Allow Azure Health Checks
az network nsg rule create -g $networkResourceGroup --nsg-name $nsg_Name -n $Allow_Azure_Ports --priority 102 --source-address-prefixes * --source-port-ranges * --destination-address-prefixes '*' `
    --destination-port-ranges 65200-65535 --access Allow --protocol * --description "Allow Azure Ports"

az network vnet subnet update -g $networkResourceGroup -n $subnet_Name --vnet-name $vnet_name --network-security-group $nsg_Name