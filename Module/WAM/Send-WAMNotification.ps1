function Send-WAMNotification {

    <#
    .SYNOPSIS
    Send's Notifications for Tests performed.

    .DESCRIPTION


    .PARAMETER

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
    12/27/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(


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

        $FromFullAddress = "$FromName <$FromAddress>"
    }
    end {

    }
}
