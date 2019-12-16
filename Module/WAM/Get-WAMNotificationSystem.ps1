function Get-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Retrieve configuration for a alerting/notification system.

    .DESCRIPTION


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
        [string]$NotificationType

    )

    begin {

    }
    process {



    }
    end {

    }
}
