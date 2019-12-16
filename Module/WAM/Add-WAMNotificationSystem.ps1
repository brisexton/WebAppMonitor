function Add-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Adds configuration settings for alerting system to the database.

    .DESCRIPTION
    With this you can add email server settings or SMS settings to send
    notification alerts.

    .PARAMETER


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
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [string]$NotificationType,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [string]$SMTPServer,

        [Parameter(ParameterSetName = "Email")]
        [string]$Username,

        [Parameter(ParameterSetName = "Email")]
        [string]$Password,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [int]$Port,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [switch]$UseSSL
    )

    begin {

    }
    process {

    }
    end {

    }
}
