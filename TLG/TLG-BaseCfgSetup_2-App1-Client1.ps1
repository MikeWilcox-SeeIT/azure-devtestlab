######################################################
##### Base Configuration test environment with Azure Resource Manager
##### https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-base-configuration-test-environment-resource-manager/
##### https://raw.githubusercontent.com/Azure/azure-content/master/articles/virtual-machines/virtual-machines-base-configuration-test-environment-resource-manager.md

cls

######################################################
##### Phase 3: Configure APP1
######################################################

######################################################
##### run these commands at the Azure PowerShell command prompt on your local computer
$rgName="SeeIT-Lab-Base"
$locName="East US"
$saName="seeitlab2015"
$vnet=Get-AzureRMVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzureRMPublicIpAddress -Name APP1-NIC -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRMNetworkInterface -Name APP1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm=New-AzureRMVMConfig -VMName APP1 -VMSize Standard_A1
$storageAcc=Get-AzureRMStorageAccount -ResourceGroupName $rgName -Name $saName
$cred=Get-Credential -Message "Type the name and password of the local administrator account for APP1."
$vm=Set-AzureRMVMOperatingSystem -VM $vm -Windows -ComputerName APP1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRMVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm=Add-AzureRMVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/APP1-TestLab-OSDisk.vhd"
$vm=Set-AzureRMVMOSDisk -VM $vm -Name APP1-TestLab-OSDisk -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRMVM -ResourceGroupName $rgName -Location $locName -VM $vm

Echo "Connect to APP1 and complete the configuration."
####  see the url below for possible alternatives from this remote script
####  https://azure.microsoft.com/en-us/documentation/templates/201-vm-domain-join/
##### Echo "When finished, hit enter to proceed with the creation of the CLIENT1 machine."
##### Pause

##### Echo "Are you ready to proceed with the creation of the CLIENT1 machine?"
##### Pause




######################################################
##### Phase 4: Configure CLIENT1
######################################################

######################################################
##### run these commands at the Azure PowerShell command prompt on your local computer
$rgName="SeeIT-Lab-Base"
$locName="East US"
$saName="seeitlab2015"
$vnet=Get-AzureRMVirtualNetwork -Name TestLab -ResourceGroupName $rgName
$pip = New-AzureRMPublicIpAddress -Name CLIENT1-NIC -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRMNetworkInterface -Name CLIENT1-NIC -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm=New-AzureRMVMConfig -VMName CLIENT1 -VMSize Standard_A1
$storageAcc=Get-AzureRMStorageAccount -ResourceGroupName $rgName -Name $saName
$cred=Get-Credential -Message "Type the name and password of the local administrator account for CLIENT1."
$vm=Set-AzureRMVMOperatingSystem -VM $vm -Windows -ComputerName CLIENT1 -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRMVMSourceImage -VM $vm -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version "latest"
$vm=Add-AzureRMVMNetworkInterface -VM $vm -Id $nic.Id
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/CLIENT1-TestLab-OSDisk.vhd"
$vm=Set-AzureRMVMOSDisk -VM $vm -Name CLIENT1-TestLab-OSDisk -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRMVM -ResourceGroupName $rgName -Location $locName -VM $vm

Echo "execution of commands at the Azure PowerShell command prompt on your local computer is complete"
Echo "Connect to CLIENT1 and complete the final configuration."
####  see the url below for possible alternatives from this remote script
####  https://azure.microsoft.com/en-us/documentation/templates/201-vm-domain-join/
