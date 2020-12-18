Function Get-Uptime {
<#
.Synopsis
    This will check how long the computer has been running and when was it last rebooted.
     
 
.PARAMETER ComputerName
    By default it will check the local computer.
 
 
    .EXAMPLE
    Get-Uptime -ComputerName IHBS-LT-SA
 
    Description:
    Check the computers IHBS-LT-SA and see how long the systems have been running for.
 
#>
 
    [CmdletBinding()]
    Param (
        [Parameter(
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
 
        [string[]]
            $ComputerName = $env:COMPUTERNAME
    )
 
    BEGIN {}
 
    PROCESS {
        Foreach ($Computer in $ComputerName) {
            $Computer = $Computer.ToUpper()
            Try {
                $OS = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
                $Uptime = (Get-Date) - $OS.ConvertToDateTime($OS.LastBootUpTime)
                [PSCustomObject]@{
                    ComputerName  = $Computer
                    LastBoot      = $OS.ConvertToDateTime($OS.LastBootUpTime)
                    Uptime        = ([String]$Uptime.Days + " Days " + $Uptime.Hours + " Hours " + $Uptime.Minutes + " Minutes")
                }
 
            } catch {
                [PSCustomObject]@{
                    ComputerName  = $Computer
                    LastBoot      = "Unable to Connect"
                    Uptime        = $_.Exception.Message.Split('.')[0]
                }
 
            } finally {
                $null = $OS
                $null = $Uptime
            }
        }
    }
 
    END {}
 
}