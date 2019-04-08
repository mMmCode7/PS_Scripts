
$mailboxIDPath = "" # forexample C:\list.txt
$outputpath = "" # forexample C:\outputlocation.txt



$Mailboxslist = Get-Content -path $mailboxIDPath
# provide the start and end date in this format (mm/dd/yyyy hh:mm:ss..mm/dd/yyyy hh:mm:ss) 

$results = @()
foreach($ID in $Mailboxslist){

    $Searchoutput = Search-mailbox -Identity $ID -SearchQuery 'Subject: "Message Subject" Received:mm/dd/yyyy hh:mm:ss..mm/dd/yyyy hh:mm:ss' -DeleteContent -force
    $results += $Searchoutput
    Write-host "$ID mailbox searched and message deleted successfully if found.." -ForegroundColor magenta
}

$results | out-file $outputpath

