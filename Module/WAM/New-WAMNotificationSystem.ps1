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

    .PARAMETER SMTPCredential
    Username and password for the SMTP Server.

    .PARAMETER Port
    Port number to be used for relaying email through SMTP server.

    .PARAMETER UseSSL
    Switch to specify whether SMTP connections should be over a
    secure channel (TLS).

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

        [Parameter(Mandatory)]
        [ValidateLength(1, 10)]
        [string]$Name,

        [Parameter()]
        [ValidateLength(1, 100)]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [string]$NotificationType,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [string]$FromName,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [string]$FromAddress,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [string]$SMTPServer,

        [Parameter(ParameterSetName = "Email")]
        [pscredential]$SMTPCredential,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [int]$Port,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [switch]$UseSSL,

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

        $FromAddress = $FromAddress.Trim(" ")
        $FromFullAddress = "$FromName <$FromAddress>"


        if ($PSBoundParameters.ContainsKey("SMTPCredential")) {
            $SMTPUsername = $SMTPCredential.UserName
            $SMTPPassword = $SMTPCredential.GetNetworkCredential().Password
        }

        $sqlQueryBuild = "INSERT INTO dbo."

        if ($PSBoundParameters.ContainsKey("Credential")) {

            try {
                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password

                Write-Verbose "Attempting to add information for $Name to the database $DatabaseName on SQL Server $ServerInstance with specified Credentials."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $BasicAppInfo -Username $UserName -Password $SQLPass -AbortOnError
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
                [int]$notifyTypeId = Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'notify_type' -SchemaName dbo -Credential $Credential | Where-Object { $_.Name -eq $Name }
                Write-Verbose "Attempting to save expected test results for web app $Name"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestInfo -Username $UserName -Password $SQLPass -AbortOnError
            } catch {
                Write-Host "Failed to add Web App $Name to the database" -ForegroundColor Red
                $Error[0]
            }

        } else {

            try {
                Write-Verbose "Attempting to add information for $Name to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $BasicAppInfo -AbortOnError
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
                [int]$webappId = Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'webapps' -SchemaName dbo | Where-Object { $_.Name -eq $Name }
                Write-Verbose "Attempting to save expected test results for web app $Name"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestInfo -AbortOnError
            } catch {
                Write-Host "Failed to add Web App $Name to the database" -ForegroundColor Red
                $Error[0]
            }

        }


    }
    end {

    }
}
