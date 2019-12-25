function Get-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Retrieve configuration for a alerting/notification system.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name for the notification/alerting system.

    .PARAMETER SystemType
    Valid options are either Email or SMS.

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

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [ValidateSet('Email', 'SMS')]
        [string]$SystemType,

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

        if ($PSBoundParameters.ContainsKey("Name")) {

        }

    }
    end {

    }
}
