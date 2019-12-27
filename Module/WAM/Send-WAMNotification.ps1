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


#>
    [CmdletBinding()]
    param(


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

        $FromFullAddress = "$FromName <$FromAddress>"
    }
    end {

    }
}
