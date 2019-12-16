function Remove-WAMNotification {

    <#
    .SYNOPSIS
    Removes a recipients address from receiving notifications.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name of the notification.

    .PARAMETER NotificationType
    Email or SMS are valid options.


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
        [string]$NotificationType

    )

    begin {

    }
    process {

    }
    end {

    }
}
