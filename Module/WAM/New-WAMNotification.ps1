function New-WAMNotification {

<#
    .SYNOPSIS
    Creates a notification system.

    .DESCRIPTION


    .PARAMETER


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES


#>
    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$Name,


        [Parameter(Mandatory)]
        [ValidateSet('Email','SMS')]
        [string]$NotificationType
    )

    begin {

    }
    process {

    }
    end {

    }
}
