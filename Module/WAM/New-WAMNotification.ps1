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

    .PARAMETER NotificationSystemId

    .PARAMETER WebAppObject


    .PARAMETER WebAppId
    The ID number of the Web Application which is being monitored that you
    want to alert on.

    .PARAMETER WebAppName
    The Name of the Web Application which is being monitored that you
    want to alert on.

    .PARAMETER AllWebApps

    .PARAMETER Enabled


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
    [CmdletBinding(SupportsShouldProcess)]
    param(

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [ValidateNotNullOrEmpty()]
        [string]$NotificationType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]$NotificationSystemId,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ByObject")]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$WebAppObject,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ById")]
        [ValidateNotNullOrEmpty()]
        [int[]]$WebAppId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string[]]$WebAppName,

        [Parameter(Mandatory, ParameterSetName = "All")]
        [ValidateNotNullOrEmpty()]
        [switch]$AllWebApps,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [switch]$Enabled,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$DatabaseName = "WebAppMonitor",

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$ServerInstance = $env:COMPUTERNAME,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [pscredential]$Credential


    )

    begin {

    }
    process {

    }
    end {

    }
}
