$cluster_name = 'AKS01'
$aks_resource_group = 'TestCompute'
$acr_resource_id = '/subscriptions/d7713b76-bdce-4b8a-bda2-987e866c6bb7/resourceGroups/TestCompute/providers/Microsoft.ContainerRegistry/registries/acrmobileprd'

az aks update -n $cluster_name -g $resource_group $aks_resource_group --attach-acr $acr_resource_id