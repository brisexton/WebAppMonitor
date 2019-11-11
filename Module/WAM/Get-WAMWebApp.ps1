#Requires -Module SqlServer
function Get-WAMWebApp {
    <#
    .SYNOPSIS
    Retrieve's Web Applications in the database

    .DESCRIPTION


    .PARAMETER ServerInstance
    The SQL Server Instance where the database lives. Default is
    the default instance on localhost.

    .PARAMETER DatabaseName
    The name of the WebAppMonitor database, if changed from the
    default name of WebAppMonitor.

    .PARAMETER Name
    The name of the Web Application that has been registered.

    .PARAMETER Active
    Whether the App is set to be actively monitored.

    .PARAMETER Credential
    SQL Credential to connect to the SQL Server Instance.


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

        [Parameter()]
        [string]$ServerInstance,

        [Parameter()]
        [string]$DatabaseName = 'WebAppMonitor',

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [switch]$Active,

        [parameter()]
        [pscredential]$Credential

    )

    begin {

    }
    process {

    }
    end {

    }
}
