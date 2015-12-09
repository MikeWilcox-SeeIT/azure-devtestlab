#### add an extra data disk as a new volume with the drive letter F:.



#### configure DC1 as a domain controller and DNS server for the corp.contoso.com domain. 
#### Run these commands at an administrator-level Windows PowerShell command prompt.

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName corp.contoso.com -DatabasePath "F:\NTDS" -SysvolPath "F:\SYSVOL" -LogPath "F:\Logs"

#### restart

