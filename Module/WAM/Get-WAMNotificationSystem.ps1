function Get-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Retrieve configuration for a alerting/notification system.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name for the notification/alerting system.

    .PARAMETER SystemType
    Valid options are either Email or SMS.

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
        [string]$SystemType

    )

    begin {

    }
    process {



    }
    end {

    }
}
