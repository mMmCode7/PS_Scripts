
$computers = get-content "$($env:USERPROFILE)\Desktop\Servers_Inventory\Server_List.txt"
$fullReport = @()

foreach($Computer in $Computers){
    write-host "Extracting information for HostName: $($Computer)" -ForegroundColor magenta
    $OSObject = (Get-WmiObject -ComputerName $Computer -Class win32_operatingsystem|Select-Object *);
    $SysObject = (Get-wmiobject -ComputerName $Computer -Class Win32_ComputerSystem|Select-Object *);
    $BIOSObject = (Get-wmiobject Win32_BIOS|Select-Object *);
    $ProcessorObject = (Get-wmiobject win32_Processor|Select-Object *);
    $DiskSize = 0;
    (Get-WmiObject Win32_LogicalDisk -Filter "DriveType='3'" |ForEach-Object{ $DiskSize+= ($_.Size)});
    $RAMSizeInGB = 0;
    [int] $RAMSizeInGB =  (($SysObject | Select-Object -ExpandProperty TotalPhysicalMemory)/1GB);
    $IPaddress = Get-WmiObject win32_networkadapterconfiguration | Where-Object {$_.Ipenabled }|Select-object -ExpandProperty IPAddress
    $Ipaddress = [system.String]::Join(" -- ", $IPaddress)
    $win32_product = @(get-wmiobject -class ‘Win32_Product’ -computer $computer)
    foreach ($app in $win32_product){
        $properties = [ordered]@{
            ComputerName = $app.PSComputerName
            Vendor = $app.vendor
            Product_Name = $app.Name
            Version = $app.Version
            Installed_Date = $app.InstallDate
            NumberOfCores = $ProcessorObject.NumberOfCores
            ProcessorThreadCount = $ProcessorObject.ThreadCount
            SerialNumber = $BIOSObject.SerialNumber
            HDDSizeinGB = $DiskSize/1GB
            RAMSizeinGB = $RAMSizeInGB
            OSArchitecture = $OSObject | Select-Object -ExpandProperty OSArchitecture
            LastScanDateAndTime = (Get-Date -Format "dd-MM-yyyy hh:mm:ss")
            OSVersion = $OSObject.Version
            SystemModel = $SysObject.Model
            SystemManufacturer = $SysObject.Manufacturer
            IPaddress = $IPaddress
            OSName = $OSObject.Caption
            NumberOfEnabledCores = $ProcessorObject.NumberOfEnabledCore
            NumebrOfLogicalProcessors = $ProcessorObject.NumberOfLogicalProcessors
            PhysicalOrVirtual = $SysObject.Model
                                }
        $applications = New-Object PSObject -Property $properties

       $fullReport += $applications
       }


}

$fullReport | export-csv "$($env:USERPROFILE)\Desktop\Servers_Inventory\fullreport.csv"

