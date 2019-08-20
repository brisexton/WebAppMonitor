function Install-WAMScheduledTask {
    <#
        .SYNOPSIS


        .DESCRIPTION


        .PARAMETER RuntimeFrequency
        How often the scheduled task should run in seconds.

        .PARAMETER InstallLocation
        The full path to where the WAM folder is located.

        .PARAMETER Credential
        Local User Credential on the server for the scheduled task to run as.

        .EXAMPLE
        $cred = Get-Credential -Message "Enter Local User Creds"
        Install-WAMScheduledTask -RuntimeFrequency 120 -InstallLocation C:\scripts\WAM -Credential $cred

        This will set the scheduled task to execute every 2 minutes (120 seconds) with
        the WAM folder located in C:\scripts

        .INPUTS


        .OUTPUTS


        .LINK


        .NOTES
        Initial
        8/19/2019
        Brian Sexton

    #>
    [CmdletBinding()]

    param (

        [Parameter(Mandatory)]
        [int]$RuntimeFrequency = 60,

        [Parameter()]
        [string]$InstallLocation,

        [Parameter(Mandatory)]
        [pscredential]$Credential

    )

    begin {

    }
    process {

    }
    end {

    }

}
