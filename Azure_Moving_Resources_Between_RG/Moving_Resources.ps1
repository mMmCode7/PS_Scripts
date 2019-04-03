Connect-AzAccount -Tenant "YourTenent.onmicrosoft.com"

# 1- Verify the resource can be moved.
# 2- Check before moving the resource if in different subscription: 
#       - The source and destination subscriptions must exist within the same Azure Active Directory Tenant
#       - The account moving the resources must have at least the following permissions:
#            --Microsoft.Resources/subscriptions/resourceGroups/moveResources/action on the source resource group.
#            --Microsoft.Resources/subscriptions/resourceGroups/write on the destination resource group.
Get-AzureRmResourceGroup | Select-object ResourceGroupName, Tags
Get-AzureRmResource | Select-Object Name,ResourceGroupName,Tags


#Selecting Destination Resource Group:
$DestinationRG = Get-AzureRmResourceGroup -Name "Resource Group Name"


#Selecting single Resource to be moved:
$SingleResource = Get-AzureRmResource | Where-Object {$_.Name -eq "Resource Name"}

#Selecting multiple Resource to be moved, 

$MultipleResources = Get-AzResource | Where-Object {$_.Tags.Keys -eq "Tage Key name"}

#moving Single Resource: 

Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $singleResource.ResourceId

#moving Multple Resources: 

foreach($Resource in $MultipleResources){
    
    write-host "Moving...$($Resource.Name)" -forgroundcolor Magenta
    Move-AzResource -DestinationResourceGroupName $DestinationRG.ResourceGroupName -ResourceId $Resource.ResourceId -force
    
} 
