# This script is used to scan for Log4J*.jar* files using SSM agent / PDQ Deploy and log them back to central repository. 
function ScanForLog4J() {

    param(
        [Parameter(mandatory=$true,position=0)]
        [string] $LogPath
    )

    $ComputerInfo = Get-ComputerInfo
    $NetworkingInfo = Get-NetIPAddress | Where-Object IpAddress -like "10.*" | Select-Object -ExpandProperty IpAddress
    $Drives = Get-PSDrive -PSProvider 'FileSystem'
    $DrivesToScan = @()
    $Drives | ForEach-Object { if($_.Used -ne '') {
            $DrivesToScan += $_.Root
        }
    }
    $DrivesToScan | ForEach-Object {
        $Results = @()
        Get-ChildItem -Path $_ -Filter '*log4j*.jar*' -Recurse -ErrorAction SilentlyContinue -Force | ForEach-Object {
            $Directory = $_.Directory
            $Name = $_.Name
            $Result = "$Directory\$Name"
            $Results += $Result
        }
        if($Results.Count -ne 0) {
            $Results | ForEach-Object {
                $Export = [PSCustomObject]@{
                    HostName = $ComputerInfo.CsName
                    Domain = $ComputerInfo.CsDomain
                    IpAddress = $NetworkingInfo
                    FilePath = $_
                }
                $Export | Select-Object HostName, Domain, IpAddress, FilePath | Export-Csv -LiteralPath "$LogPath\Log4J.csv" -Append
            }
        }
        else {
            Write-Host "Log4J Not Found"
        }
    }
}

ScanForLog4J -LogPath ''
