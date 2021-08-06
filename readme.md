# Simple function to check changes in role assigments of Azure AD 

Simple function to show difference between previous and current role assignments

-  PS Output will show the difference when comparing the objects with sideIndicator indicating the difference
```PowerShell
Compare-Object -ReferenceObject $existing -DifferenceObject $mbrs;
```
```
InputObject                                                                                                   SideIndicator
-----------                                                                                                   -------------
@{ObjectId=c0ba0d53-274c-4f52-ae0a-d50950383fda; DisplayName=https://Recovery-breakglass.dewi.red; userType=} =>

```

## Function
```Powershell
# Get the roles you want to be used in the function 
Get-AzureADDirectoryRole

#Roles below for Global admins and Security Reader 
$roles = "862e258d-ffac-40fd-aa9d-7b2a990c3070,09dc17e0-996d-4b81-ac46-1925550d6ddc" -split ","

#Init roles 
#Roles below
$roles = "862e258d-ffac-40fd-aa9d-7b2a990c3070,09dc17e0-996d-4b81-ac46-1925550d6ddc" -split ","


#Function will check change in role. If role file does not exist, or import of the file fails, it will overwrite with new file
function RoleChecker ($roleId) {

  $mbrs = Get-AzureADDirectoryRoleMember -ObjectId $role | select -Property ObjectId, DisplayName, userType

 try {
write-host "trying to read existing roles" -ForegroundColor Green
$existing = import-csv "$roleId.csv"

$diff = Compare-Object -ReferenceObject $existing -DifferenceObject $mbrs;
Write-Host "check diff" $mbrs.count, "vs" $existing.count -ForegroundColor Yellow

if ($diff -and $mbrs ) {
    write-host "updating file for id $role"
    if ($mbrs) { $mbrs | Export-Csv "./$role.csv" -NoTypeInformation -Force}
    $diff
}


 } catch  {
     write-host "no existing file creating file"
     if ($mbrs) { $mbrs | Export-Csv "./$role.csv" -NoTypeInformation -Force}
    
 }



}

foreach ($role in $roles) {
    Write-Host $role
  RoleChecker -roleId $role


}
``` 

