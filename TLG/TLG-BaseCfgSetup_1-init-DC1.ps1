######################################################
##### Base Configuration test environment with Azure Resource Manager
##### https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-base-configuration-test-environment-resource-manager/
##### https://raw.githubusercontent.com/Azure/azure-content/master/articles/virtual-machines/virtual-machines-base-configuration-test-environment-resource-manager.md

cls

######################################################
##### Phase 1: Create the virtual network
######################################################


######################################################
##### To determine a unique resource group name, use this command to list your existing resource groups.
##### Get-AzureRMResourceGroup | Sort ResourceGroupName | Select ResourceGroupName

######################################################
##### Create your new resource group with these commands. 
$rgName="SeeIT-Lab-Base"
$locName="East US"
New-AzureRMResourceGroup -Name $rgName -Location $locName


######################################################
##### You must pick a globally unique name for your storage account that contains only lowercase letters and numbers. 
##### You can use this command to list the existing storage accounts.
##### Get-AzureRMStorageAccount | Sort Name | Select Name

######################################################
##### Create a new storage account for your new test environment with these commands.
##### $rgName="SeeIT-Lab-Base"
##### $locName="East US"
$saName="seeitlab2015"
New-AzureRMStorageAccount -Name $saName -ResourceGroupName $rgName –Type Standard_LRS -Location $locName

######################################################
##### create the TestLab Azure Virtual Network that will host the Corpnet subnet of the base configuration.
##### $rgName="SeeIT-Lab-Base"
##### $locName="East US"
$corpnetSubnet=New-AzureRMVirtualNetworkSubnetConfig -Name Corpnet -AddressPrefix 10.0.0.0/24
New-AzureRMVirtualNetwork -Name TestLab -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/8 -Subnet $corpnetSubnet –DNSServer 10.0.0.4


######################################################
##### Phase 2: Configure DC1
######################################################

######################################################
##### run these commands at the Azure PowerShell command prompt on your local computer
##### $rgName="SeeIT-Lab-Base"
##### $locName="East US"
##### $saName="seeitlab2015"
$vnet=Get-AzureRMVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzureRMPublicIpAddress -Name DC1-NIC -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRMNetworkInterface -Name DC1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -PrivateIpAddress 10.0.0.4
$vm=New-AzureRMVMConfig -VMName DC1 -VMSize Standard_A1
$storageAcc=Get-AzureRMStorageAccount -ResourceGroupName $rgName -Name $saName
$vhdURI=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/DC1-TestLab-ADDSDisk.vhd"
Add-AzureRMVMDataDisk -VM $vm -Name ADDS-Data -DiskSizeInGB 20 -VhdUri $vhdURI  -CreateOption empty
$cred=Get-Credential -Message "Type the name and password of the local administrator account for DC1."
$vm=Set-AzureRMVMOperatingSystem -VM $vm -Windows -ComputerName DC1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRMVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm=Add-AzureRMVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/DC1-TestLab-OSDisk.vhd"
$vm=Set-AzureRMVMOSDisk -VM $vm -Name DC1-TestLab-OSDisk -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRMVM -ResourceGroupName $rgName -Location $locName -VM $vm

Echo "Connect to DC1 and complete the configuration."
##### Echo "When finished, hit enter to proceed with the creation of the APP1 machine."
##### Pause

##### Echo "Are you ready to proceed with the creation of the APP1 machine?"
##### Pause

