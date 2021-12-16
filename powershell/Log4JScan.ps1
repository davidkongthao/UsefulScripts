# This script is used to scan for Log4J*.jar* files using SSM agent / PDQ Deploy and log them back to central repository. 
function ScanForLog4J() {

    param(
        [Parameter(mandatory=$true,position=0)]
        [string] $LogPath,
        [Parameter(mandatory=$true,position=1)]
        [string] $LogServerIP
    )
    
    $SmbMappings = Get-SmbMapping -RemotePath $LogPath -ErrorAction SilentlyContinue
    if($SmbMappings -ne $null) {
        $SmbMappings | ForEach-Object { Remove-SmbMapping -LocalPath $_.LocalPath -Force }
    }
    $AvailableDrive = ls function:[d-z]: -n | ?{ !(Test-Path $_) } | random
    if ($AvailableDrive -eq "") {
        Write-Host "No drive available."
        exit 1
    }
    try {
        New-SmbMapping -LocalPath $AvailableDrive -RemotePath $LogPath -UserName $username -Password $password -ErrorAction Stop
    } catch {
        Write-Host "Unable to make network connection to destination drive."
        exit 1
    }
    $ComputerInfo = Get-ComputerInfo
    $NetworkingInfo = Get-NetIPAddress | Where-Object IpAddress -like "10.*" | Select-Object -ExpandProperty IpAddress
    $Drives = Get-PSDrive -PSProvider FileSystem
    $DrivesToScan = @()
    $Drives | ForEach-Object { if($_.DisplayRoot -eq $null) {
            $DrivesToScan += $_.Root
        }
    }
    $DrivesToScan | ForEach-Object {
        $Results = @()
        Get-ChildItem -Path $_ -Filter '*log4j*.jar*' -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object {
            $Result = $_.FullName
            $Results += $Result
        }
        $CSName = $ComputerInfo.CsName
        if($Results.Count -ne 0) {
            $Results | ForEach-Object {
                $Export = [PSCustomObject]@{
                    HostName = $CSName
                    Domain = $ComputerInfo.CsDomain
                    IpAddress = $NetworkingInfo
                    FilePath = $_
                }
                $Export | Out-File -FilePath "$LogPath\$CSName-Log4J.txt" -Append -Width 9000000
            }
        }
        else {
            Write-Host "Log4J Not Found in $Directory"
            exit 0
        }
    }
    Remove-SmbMapping -LocalPath $AvailableDrive -Confirm:$false
}

ScanForLog4J -LogPath '\\10.101.25.21\Log4J' -LogServerIP '10.101.25.21'
