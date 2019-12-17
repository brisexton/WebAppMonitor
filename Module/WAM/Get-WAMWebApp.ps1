#Requires -Module SqlServer
function Get-WAMWebApp {
    <#
    .SYNOPSIS
    Retrieve's Web Applications in the database

    .DESCRIPTION


    .PARAMETER Name
    The name of the Web Application that has been registered.

    .PARAMETER Active
    Whether the App is set to be actively monitored.

    .PARAMETER DatabaseName
    The name of the database used by WebAppMonitor. The default value is
    WebAppMonitor.

    .PARAMETER ServerInstance
    The Instance of SQL Server where the database is located.

    .PARAMETER Credential
    SQL Login credentials to connect to the SQL Server Instance.


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Initial
    11/10/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter(ParameterSetName = "Name")]
        [string]$Name,

        [Parameter(ParameterSetName = "Active")]
        [switch]$Active,

        [Parameter()]
        [string]$DatabaseName = "WebAppMonitor",

        [Parameter()]
        [string]$ServerInstance = $env:COMPUTERNAME,

        [Parameter()]
        [pscredential]$Credential

    )

    begin {

    }
    process {

        if ($PSBoundParameters.ContainsKey($Active)) {
            $sqlQuery = 'SELECT * FROM [dbo].[appinfo] WHERE monitor_active = TRUE'
        } elseif ($PSBoundParameters.ContainsKey($Name)) {
            $sqlQuery = "SELECT * FROM [dbo].[appinfo] WHERE name LIKE %$Name%"
        } else {
            $sqlQuery = 'SELECT * FROM [dbo].[appinfo]'
        }

        if ($PSBoundParameters.ContainsKey($Credential)) {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with sql creds"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Credential $Credential -OutputAs DataRows -ErrorAction Stop
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -OutputAs DataRows -ErrorAction Stop
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        }
    }
    end {

    }
}
