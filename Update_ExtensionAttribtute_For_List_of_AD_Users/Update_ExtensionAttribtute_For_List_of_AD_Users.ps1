Install-Module ImportExcel
Import-Module Activedirectory

$Excel_location = "Excel path"   # Example C:\UsersInfo.xlsx
# excel must have two columns named as ( ADID -  Attribute )

$users = Import-Excel $Excel_location

$extensionAttributeName = "" #provide extensionattribute name example (extensionAttribute11)



foreach($user in $users){

    Set-ADUser -Identity $user.ADID -Clear $($extensionAttributeName)
    Set-ADUser -Identity $user.ADID -Add @{$($extensionAttributeName) = "$($user.Attribute)"}

    Write-Host "$user updated...." -ForegroundColor Magenta
}

