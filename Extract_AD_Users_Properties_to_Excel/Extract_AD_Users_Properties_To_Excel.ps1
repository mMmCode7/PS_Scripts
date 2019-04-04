Install-Module ImportExcel
Import-Module ActiveDirectory

$users = Get-Content ".txt file location" # Example C:\allusers.txt
$outputPath = ".xlsx output file path"    # Example C:\allusers.xlsx
$output = @()
foreach($user in $users){
$userinfo = Get-ADUser -Identity $user -Properties userprincipalname,SamAccountName,EmailAddress,City,Company,Department,DisplayName,GivenName,Surname,Initials,OfficePhone,Title,extensionAttribute1, `
extensionAttribute2,extensionAttribute3,extensionAttribute4,extensionAttribute5,extensionAttribute6,extensionAttribute7,extensionAttribute8,extensionAttribute9, `
extensionAttribute10,extensionAttribute11,extensionAttribute12,extensionAttribute13,extensionAttribute14,extensionAttribute15 |
select-Object userprincipalname,SamAccountName,EmailAddress,City,Company,Department,DisplayName,GivenName,Surname,Initials,OfficePhone,Title,extensionAttribute1, `
extensionAttribute2,extensionAttribute3,extensionAttribute4,extensionAttribute5,extensionAttribute6,extensionAttribute7,extensionAttribute8,extensionAttribute9, `
extensionAttribute10,extensionAttribute11,extensionAttribute12,extensionAttribute13,extensionAttribute14,extensionAttribute15

Write-Host "$user extracted...."

$output += $userinfo
}
$output | export-excel "$($outputPath)"
