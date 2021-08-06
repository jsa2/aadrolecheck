#Connect-AzureAD
<# Get RoleID's
Get-AzureADDirectoryRole
#>

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