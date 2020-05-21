#*********BEGIN ASSIGN VARIABLES***********#

$subscription_name = 'PD-DEV'
$resource_group_name = 'ArmTemplatesTest'

#*********END ASSIGN VARIABLES***********#

#Set subscription
az account set --subscription $subscription_name
Write-Output "Setting deployment name as '$deployment_name'"

$deployment_name = $PSScriptRoot.Split([IO.Path]::DirectorySeparatorChar).GetValue($PSScriptRoot.Split([IO.Path]::DirectorySeparatorChar).Count-1)

#Check if resource group already exists if not create one
$resource_group_exists = az group  exists --resource-group $resource_group_name

if(-NOT ($resource_group_exists -eq 'true')){
    az group create --name $resource_group_name -l eastus 
}
else{
    Write-Output "resource group already exists"
}


New-AzResourceGroupDeployment -Name $deployment_name -ResourceGroupName $resource_group_name -TemplateFile $PSScriptRoot\template.json -TemplateParameterFile $PSScriptRoot\parameters.json