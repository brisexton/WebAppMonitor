#requires -Version 4.0
function Install-WAMDatabase {
<#
    .SYNOPSIS
    Creates the database for WebAppMonitor.

    .DESCRIPTION
    Executes SQL Queries to setup the database. This cmdlet requires either
    SqlServer or SQLPS.

    .PARAMETER ServerInstance
    Default value is is localhost

    .PARAMETER DatabaseName
    Name of the SQL Database to be created. The default value is WebAppMonitor.

    .PARAMETER Credential
    SQL Login to connect to the Database Engine to create the Database.

    .EXAMPLE
    Install-WAMDatabase

    Creates database and tables on local default instance using Windows Authentication.

    .EXAMPLE
    $sqlCreds = Get-Credential
    Install-WAMDatabase -ServerInstance 'SERVER1\INSTANCE1' -Credential $sqlCreds

    This creates the database with the default name of WebAppMonitor and tables
    on SQL Server Instance SERVER1\INSTANCE1 and connects with $sqlCreds


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Initial
    8/19/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ServerInstance,

        [Parameter()]
        [string]$DatabaseName = "WebAppMonitor",

        [Parameter()]
        [pscredential]$Credential
    )

    begin {

    }
    process {

        $NewDatabaseStatement = "CREATE DATABASE $DatabaseName"

        $NewDatabaseTables = @"

"@

        if ($PSBoundParameters.ContainsKey($Credential))
        {

            try {
                Write-Verbose "Attempting to Create Database $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $NewDatabaseStatement -Credential $Credential -ErrorAction Stop
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
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $NewDatabaseStatement -ErrorAction Stop
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
