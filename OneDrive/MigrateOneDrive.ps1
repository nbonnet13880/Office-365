$PATHCSV = "C:\Users\eu01nbonnet\Desktop\PATH.csv"
$PATHCSVLISTFOLDER = "C:\Users\eu01nbonnet\Desktop\Migration.csv"
$PATHCSONEDRIVE = "C:\Users\eu01nbonnet\Desktop\OneDrive.csv"
$IMPORTCSV = Import-Csv $PATHCSV

ForEach ($item in $IMPORTCSV)

{

$PATH = Test-Path $item.PATH

if ($PATH -eq $True)
{
    Write-Host "The path" + $item.PATH "exist"
}
else
{
    Write-Host "The path" + $item.PATH "does not exist"
    break
}


$Network = New-Object -ComObject "Wscript.Network"
$Network.MapNetworkDrive("X:", $item.PATH)

$PATH = Test-Path 'x:'

if ($PATH -eq $True)
{
    Write-Host "Map of the network drive is now OK"
    
}
else
{
    Write-Host "There is a problem for map network drive"
    break
}

#Import-Csv -Path $PATHCSONEDRIVE  -header 'DIRECTORY, ONEDRIVEURL'

#dir –Directory X:\ -Name | Out-File $PATHCSVLISTFOLDER
Get-ChildItem -Path "X:\" | select Name | Export-Csv -Path $PATHCSVLISTFOLDER -Delimiter "," -NoTypeInformation

$PATH = Test-Path $PATHCSVLISTFOLDER

if ($PATH -eq $True)
{
    Write-Host "CSV File migration.csv has been created"
    
}
else
{
    Write-Host "There is a problem with csv file migration.csv"
    break
}

$lines = Import-Csv $PATHCSVLISTFOLDER
#$MAXLINE=$lines.Count

$results = @()

foreach ($line in $lines) {

    #Write-Host $line.Name

    #Build UNC
    $UNCPath ="x:\" + $line.Name

    # Create PS Object
    $results += [pscustomobject] @{
    'LocalPath' = $UNCPath
    'OneDrivePath' = $item.URL
    }

}

$results | Export-Csv -Path $PATHCSONEDRIVE -Delimiter "," -NoTypeInformation
<#
$i=0
 Do {
    $test ="x:\" + $lines[$i].FOLDERS + "," + $item.path | out-file -LiteralPath $PATHCSONEDRIVE -Append
    $i++
    }
 While ($i -lt $MAXLINE)
#>

#ForEach ($line in $lines)
#{
#$N='0'
#$test ="x:\$line[$N].Favorites,$item.path"
#$employees | Export-Csv -Path C:\Employees2.csv
#}


}

