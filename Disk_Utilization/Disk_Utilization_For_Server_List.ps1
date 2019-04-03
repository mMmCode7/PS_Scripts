$outputLocaiton = "C:\DiskUtilization.xlsx"
[array]$computers = Get-Content -path "c:\ServerList.txt"

#Creatig excel files
$excel = New-Object -ComObject excel.application
$excel.visible = $False
$excel.DisplayAlerts = $False
$workbook = $excel.Workbooks.Add()
$excel.Rows.Item(1).Font.Bold = $true
$value1= $workbook.Worksheets.Item(1)
$value1.Name = 'Capacity info'
$value1.Cells.Item(1,1) = "Machine Name"
$value1.Cells.Item(1,2) = "Memory Utilization"
$value1.Cells.Item(1,3) = "CPU Utilization"
$value1.Cells.Item(1,4) = "Partition Capacity "
$value1.Cells.Item(1,5) = "Partition Used Space "
$value1.Cells.Item(1,6) = "Partition Free Space "
$value1.Cells.Item(1,7) = "Partition Utilization %"

 $row = 2
 $column = 1
foreach($computer in $computers) 
 {  
 $value1.Cells.Item($row, $column) = $computer
 $column++
# Start processing RAM 		
  $Mem = Get-WmiObject win32_operatingsystem -ComputerName $computer | Select-Object @{Name = "MemoryUsage"; `
              Expression = {"{0:N2}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}
$Memoryinfo = $Mem.MemoryUsage
$value1.Cells.Item($row, $column) = "$($Memoryinfo)%"
$column++

# Processing CPU capacity: 
$pro = Get-WmiObject -ComputerName $computer win32_processor | Measure-object -Property LoadPercentage -Average
$ProUtilization = $pro.Average
$value1.Cells.Item($row, $column) = "$($ProUtilization)%"
$column++

#Disk Informattion
 $disks = Get-WmiObject -ComputerName $computer -Class Win32_LogicalDisk -Filter "DriveType = 3" 
 $computer = $computer.toupper() 
  foreach($disk in $disks) 
 {         
  $deviceID = $disk.DeviceID; 
   $volName = $disk.VolumeName; 
  [float]$size = $disk.Size; 
  [float]$freespace = $disk.FreeSpace;  
  $percentFree = [Math]::Round(($freespace / $size) * 100); 
  $sizeGB = [Math]::Round($size / 1073741824, 2); 
  $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2); 
  $usedSpaceGB = $sizeGB - $freeSpaceGB; 
  $value1.Cells.Item($row, $column) = "$($deviceID) $($sizeGB)GB"
  $SizeColumn = $column
  $column++
  $value1.Cells.Item($row, $column) = "$($deviceID) $($usedSpaceGB)GB"
  $column++
  $value1.Cells.Item($row, $column) = "$($deviceID) $($freeSpaceGB)GB"
  $column++
  $value1.Cells.Item($row, $column) = "$($deviceID) $($percentFree)%"
  $column++
  $row++
  $column = $SizeColumn
  
        }
$column = 1
$row++
}


$workbook.SaveAs($outputLocaiton) 
$excel.Quit()
