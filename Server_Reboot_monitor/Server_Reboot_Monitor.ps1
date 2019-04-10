
$outputLocaiton = "" # where the final report will be exported Example "C:\Reboot.xlsx"
$serverList = "" # where the list of servers to be checked will be store example "C:\serverlist.txt"

[array]$allcomputers = Get-Content -Path $serverList
#Creatig excel files
$excel = New-Object -ComObject excel.application
$excel.visible = $False
$excel.DisplayAlerts = $False
$workbook = $excel.Workbooks.Add()
$excel.Rows.Item(1).Font.Bold = $true
$value1= $workbook.Worksheets.Item(1)
$value1.Name = 'Reboot Info'
$value1.Cells.Item(1,1) = "Computer_Name"
$value1.Cells.Item(1,2) = "Latest_Reboot_Time"
$value1.Cells.Item(1,3) = "UserName"
$value1.Cells.Item(1,4) = "Comment"
$value1.Cells.Item(1,5) = "Up_Time"

# Testing computer Reachablity:
[Array]$Computers =@()
[Array]$NotReachable =@()
foreach ($Machine in $allcomputers) {
    if(Test-Connection -ComputerName $Machine -Count 1 -Quiet) { 
                $Computers += $Machine 
                }else{
                $NotReachable += $Machine
                    }
             }
$row = 2
$Column = 1
foreach($Computer in $Computers)
{
    $value1.Cells.Item($row, $column) = $Computer
    $allLog = get-eventlog -ComputerName $Computer -LogName System -Source USER32 -Newest 100 
    $FLogs = @()
    foreach($log in $allLog)
    {
        if($log.EventID -eq 1074)
        {
            $Flogs+= $log
            
        }
    
    }
    $Column++
    $value1.Cells.Item($row, $column) = $flogs[0].TimeGenerated
    $Column++
    $value1.Cells.Item($row, $column) = $FLogs[0].UserName
    $Column++
    $value1.Cells.Item($row, $column) = $FLogs[0].Message
    $Column++
    $wmi = Get-WmiObject -ComputerName $Computer -Class Win32_OperatingSystem  
    $value1.Cells.Item($row, $column) = $wmi.ConvertToDateTime($wmi.LastBootUpTime)
    $Column = 1
    $row++
}

foreach ($Machine in $NotReachable){

$value1.Cells.Item($row, $column) = $Machine
$row++
}


$workbook.SaveAs($outputLocaiton) 
$excel.Quit()
