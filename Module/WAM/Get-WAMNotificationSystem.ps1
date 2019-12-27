function Get-WAMNotificationSystem {

    <#
    .SYNOPSIS
    Retrieve configuration for a alerting/notification system.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name for the notification/alerting system.

    .PARAMETER SystemType
    Valid options are either Email or SMS.

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
    12/16/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter()]
        [ValidateLength(1, 20)]
        [string]$Name,

        [Parameter()]
        [ValidateSet('Email', 'SMS')]
        [string]$SystemType = 'Email',

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

        If ($SystemType -eq "SMS") {
            Write-Error -Message "The database schema hasn't been extended to support SMS Notifications yet." -Category NotImplemented
            throw;
        }

        if ($SystemType -eq "Email") {
            $sqlStatement = "SELECT * FROM [dbo].[smtpconfiguration]"
        }



        if ($PSBoundParameters.ContainsKey("Credential")) {

            $SQLLoginUserName = $Credential.UserName
            $SQLLoginPassword = $Credential.GetNetworkCredential().Password

            try {
                Write-Verbose "Attempting to retrieve email configuration settings."
                if ($PSBoundParameters.ContainsKey("Name")) {
                    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatement -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError | Where-Object { $_.notifysystem_name -like "*$Name*" }
                } else {
                    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatement -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                }

            } catch {
                Write-Host "Failed to execute Sql Query $sqlStatement against database $DatabaseName on instance $ServerInstance with specified credentials." -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to retrieve email configuration settings."
                if ($PSBoundParameters.ContainsKey("Name")) {
                    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatement -OutputAs DataRows -AbortOnError | Where-Object { $_.notifysystem_name -like "*$Name*" }
                } else {
                    Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatement -OutputAs DataRows -AbortOnError
                }
            } catch {
                Write-Host "Failed to execute Sql Query $sqlStatement against database $DatabaseName on instance $ServerInstance." -ForegroundColor Red
                $Error[0]
            }
        }

    }
    end {

    }
}
