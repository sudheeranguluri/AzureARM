$resource_group_name = 'ArmTemplatesTest'
$resource_group_exists = az group  exists --resource-group $resource_group_name
$deployment_name = $PSScriptRoot.Split([IO.Path]::DirectorySeparatorChar).GetValue($PSScriptRoot.Split([IO.Path]::DirectorySeparatorChar).Count-1)


#Check if resource group already exists if not create one
if(-NOT ($resource_group_exists -eq 'true')){
    az group create --name $resource_group_name -l eastus 
}
else{
    Write-Output "resource group already exists"
}

Write-Output "Setting deployment name as '$deployment_name'"

#Private end point from AKS to SQL
New-AzResourceGroupDeployment -Name $deployment_name -ResourceGroupName $resource_group_name -TemplateFile $PSScriptRoot\template.json -TemplateParameterFile $PSScriptRoot\parameters-aks-sql.json

#Private end point from AKS to storage account
New-AzResourceGroupDeployment -Name $deployment_name -ResourceGroupName $resource_group_name -TemplateFile $PSScriptRoot\template.json -TemplateParameterFile $PSScriptRoot\parameters-aks-storage.json

#Private end point from AKS to keyvault
New-AzResourceGroupDeployment -Name $deployment_name -ResourceGroupName $resource_group_name -TemplateFile $PSScriptRoot\template.json -TemplateParameterFile $PSScriptRoot\parameters-aks-keyvault.json