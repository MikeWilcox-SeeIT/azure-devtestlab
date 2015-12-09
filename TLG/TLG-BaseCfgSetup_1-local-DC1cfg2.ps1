
#### create a user account in Active Directory that will be used when logging in to CORP domain member computers. 
#### Run these commands one at a time at an administrator-level Windows PowerShell command prompt.

New-ADUser -SamAccountName User1 -AccountPassword (read-host "Set user password" -assecurestring) -name "User1" -enabled $true -PasswordNeverExpires $true -ChangePasswordAtLogon $false
Add-ADPrincipalGroupMembership -Identity "CN=User1,CN=Users,DC=corp,DC=contoso,DC=com" -MemberOf "CN=Enterprise Admins,CN=Users,DC=corp,DC=contoso,DC=com","CN=Domain Admins,CN=Users,DC=corp,DC=contoso,DC=com"


#### reconnect using the CORP\User1 account
#### allow traffic for the Ping tool, 
#### run this command at an administrator-level Windows PowerShell command prompt

Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True