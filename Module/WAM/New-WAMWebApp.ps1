function New-WAMWebApp {
<#
    .SYNOPSIS
    Adds a URL to the database to be monitored.

    .DESCRIPTION


    .PARAMETER Url
    The URL to monitor.

    .PARAMETER StatusCode
    The HTTP status code that should be returned.

    .PARAMETER IsMonitored
    Set's the URL If you want set the URL to be monitored. Use this switch.

    .PARAMETER Database
    The name of the database used by WebAppMonitor. The default value is
    WebAppMonitor.

    .PARAMETER ServerInstance
    The Instance of SQL Server where the database is located.

    .PARAMETER Credential
    A SQL Login to connect to the database engine and write information.


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES


#>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [ValidateLength(1,50)]
        [string]$Name,

        [Parameter()]
        [ValidateLength(1,160)]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidatePattern("^http")]
        [string]$Url,

        [Parameter(Mandatory)]
        [int]$StatusCode,

        [Parameter()]
        [ValidateSet("GET","HEAD","POST","PUT","TRACE")]
        [string]$Method = "GET",

        [Parameter()]
        [string]$ContentType,

        [Parameter()]
        [switch]$IsMonitored,

        [Parameter()]
        [string]$Database = "WebAppMonitor",

        [Parameter(Mandatory)]
        [string]$ServerInstance,

        [Parameter()]
        [pscredential]$Credential

    )

    begin {

    }
    process {



        if($PSBoundParameters.ContainsKey($IsMonitored)) {
            $MonitorState = 1
        } else {
            $MonitorState = 0
        }

        $SQLQuery = "CREATE DATABASE $DatabaseName"

        if ($PSBoundParameters.ContainsKey($Credential))
        {

            try {
                Write-Verbose "Attempting to add information for $Name to the database $Database on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $SQLQuery -Credential $Credential -ErrorAction Stop
            }
            catch {
                Write-Host "Failed to Create Database" -ForegroundColor Red
                $Error[0]
            }
        }
        else
        {

            try {
                Write-Verbose "Attempting to Create Database $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $SQLQuery -ErrorAction Stop
            }
            catch {
                Write-Host "Failed to Create Database" -ForegroundColor Red
                $Error[0]
            }
        }


    }
    end {

    }

}
