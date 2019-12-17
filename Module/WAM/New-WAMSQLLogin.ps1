function New-WAMSQLLogin {

    <#
    .SYNOPSIS
    Creates a new SQL Login to be used to connect to the database
    during continuous runs

    .DESCRIPTION


    .PARAMETER SQLLoginUserName
    Username for SQL Login to be used by WebAppMonitor for continuous runs.

    .PARAMETER SQLLoginPassword
    Password for SQL Login to be used by WebAppMonitor for continuous runs.

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
    12/16/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SQLLoginUserName,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [securestring]$SQLLoginPassword,

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



    }
    end {

    }
}
