function New-WAMNotification {

    <#
    .SYNOPSIS
    Adds a notification destination to the database.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name of the alert.

    .PARAMETER Description
    A description or additional information about the alert destination.

    .PARAMETER NotificationType
    This establishes a link between the notification addresse and the
    system to be used for sending the notification/alert.

    .PARAMETER WebAppId
    The ID number of the Web Application which is being monitored that you
    want to alert on.

    .PARAMETER WebAppName
    The Name of the Web Application which is being monitored that you
    want to alert on.

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
    Update
    12/16/2019
    Brian Sexton

    Initial
    11/12/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [string]$NotificationType,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "WebAppId")]
        [int[]]$WebAppId,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "WebAppName")]
        [string[]]$WebAppName,

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
