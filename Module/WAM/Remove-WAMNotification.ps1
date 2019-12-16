function Remove-WAMNotification {

    <#
    .SYNOPSIS
    Removes a recipients address from receiving notifications.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name of the notification.

    .PARAMETER NotificationType
    Email or SMS are valid options.

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

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name,

        [Parameter()]
        [ValidateSet('Email', 'SMS')]
        [string]$NotificationType,

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
