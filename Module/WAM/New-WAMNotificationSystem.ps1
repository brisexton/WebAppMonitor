function New-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Adds configuration settings for alerting system to the database.

    .DESCRIPTION
    With this you can add email server settings or SMS settings to send
    notification alerts.

    .PARAMETER Name
    Friendly name for the alerting system.

    .PARAMETER Description
    Parameter to add additional information for the notification system.

    .PARAMETER NotificationType
    Valid choices are Email or SMS

    .PARAMETER SMTPServer
    Email server used for relay

    .PARAMETER Username
    Username for the SMTP server.

    .PARAMETER Password
    Password for the SMTP server.

    .PARAMETER Port
    Port number to be used for relaying email through SMTP server.

    .PARAMETER UseSSL
    Switch to specify whether SMTP connections should be over a
    secure channel (TLS).


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
