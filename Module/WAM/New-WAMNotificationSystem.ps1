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
        [ValidateLength(1, 20)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateLength(1, 100)]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [ValidateNotNullOrEmpty()]
        [string]$NotificationType,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [string]$FromName,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern("^[a-zA-Z0-9.!£#$%&'^_`{}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")]
        [string]$FromAddress,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [string]$SMTPServer,

        [Parameter(ParameterSetName = "Email")]
        [ValidateNotNullOrEmpty()]
        [pscredential]$SMTPCredential,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [ValidateRange(1, 32767)]
        [ValidateNotNullOrEmpty()]
        [int]$Port,

        [Parameter(Mandatory, ParameterSetName = "Email")]
        [switch]$UseSSL,

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

        if ($NotificationType -eq "SMS") {
            Write-Error -Message "The database schema hasn't been extended for this yet." -Category NotImplemented
            throw;
        }

        if ($PSBoundParameters.ContainsKey("Description")) {
            $Description = $Description -replace "`'", ""
            $sqlStatementBasic = @"
            INSERT INTO dbo.notificationsystem
                (notifysystem_type, notifysystem_name, notifysystem_description)
            VALUES
              (`'$NotificationType`', `'$Name`', `'$Description`')
"@
        } else {
            $sqlStatementBasic = @"
            INSERT INTO dbo.notificationsystem
                (notifysystem_type, notifysystem_name)
            VALUES
            (`'$NotificationType`', `'$Name`')
"@
        }

        if ($PSBoundParameters.ContainsKey("Credential")) {

            try {
                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password

                Write-Verbose "Attempting to add notification system name and description to databse for $Name to the database $DatabaseName on SQL Server $ServerInstance with specified Credentials."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatementBasic -Username $UserName -Password $SQLPass -AbortOnError
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
                [int]$notifySystemId = (Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'notificationsystem' -SchemaName dbo -Credential $Credential | Where-Object { $_.notifysystem_name -eq $Name }).notifysystem_id
            } catch {
                Write-Host "Failed to add notification system name $Name to the database" -ForegroundColor Red
                $DontGoFurther = $true
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to add notification system name and description to databse for $Name to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlStatementBasic -AbortOnError
                Write-Verbose "Retrieving the notification system id from $DatabaseName for webapp $Name"
                [int]$notifySystemId = (Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'notificationsystem' -SchemaName dbo | Where-Object { $_.notifysystem_name -eq $Name }).notifysystem_id

            } catch {
                Write-Host "Failed to add notification system name $Name to the database" -ForegroundColor Red
                $DontGoFurther = $true
                $Error[0]
            }
        }

        if ($DontGoFurther) {
            throw "Connot Continue"
        }

        if ($PSCmdlet.ParameterSetName -eq "Email") {
            $FromAddress = $FromAddress.Trim(" ")

            if ($UseSSL) {
                $EncryptedConnection = 1
            } else {
                $EncryptedConnection = 0
            }

            if ($PSBoundParameters.ContainsKey("SMTPCredential")) {

                $SMTPUsername = $SMTPCredential.UserName
                $SMTPPassword = $SMTPCredential.GetNetworkCredential().Password

                $sqlStatememntExtended = @"
                INSERT INTO dbo.emailconfig
                    (notifysystem_id, from_name, from_address, servername, smtpserver_username, smtpserver_password, port, usessl)
                VALUES
                    ($notifySystemId, `'$FromName`', `'$FromAddress`', `'$SMTPServer`', `'$SMTPUsername`', `'$SMTPPassword`', $Port, $EncryptedConnection)
"@
            } else {
                $sqlStatememntExtended = @"
                INSERT INTO dbo.emailconfig
                    (notifysystem_id, from_name, from_address, servername, port, usessl)
                VALUES
                    ($notifySystemId, `'$FromName`', `'$FromAddress`', `'$SMTPServer`', $Port, $EncryptedConnection)
"@
            }
        }

        $sqlStatementBasicRemove = "DELETE FROM dbo.notificationsystem WHERE notifysystem_id = $notifySystemId"

        if ($PSBoundParameters.ContainsKey("Credential")) {

            try {
                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password

                Write-Verbose "Attempting to save configuration information for notification system called $Name with specified credentials."
                Invoke-Sqlcmd -ServerInstance $SQLInstance -Database $DatabaseName -Query $sqlStatememntExtended -Username $UserName -Password $SQLPass -AbortOnError
                Write-Verbose "Successfully saved configuration information for $Name with specified credentials. "
            } catch {
                Write-Host "Failed to add configuration information to the database for $Name with the credential specified." -ForegroundColor Red
                $Error[0]
                Write-Verbose "Attempting to remove basic information for $Name with specified credentials."
                Invoke-Sqlcmd -ServerInstance $SQLInstance -Database $DatabaseName -Query $sqlStatementBasicRemove -Username $UserName -Password $SQLPass -OutputSqlErrors $true

            }
        } else {
            try {
                Write-Verbose "Attempting to save configuration information for notification system called $Name."
                Invoke-Sqlcmd -ServerInstance $SQLInstance -Database $DatabaseName -Query $sqlStatememntExtended -AbortOnError
                Write-Verbose "Successfully added configuration information for $Name to the database."
            } catch {
                Write-Host "Failed to add configuration information to the database for $Name." -ForegroundColor Red
                $Error[0]
                Write-Verbose "Attempting to remove basic information for $Name"
                Invoke-Sqlcmd -ServerInstance $SQLInstance -Database $DatabaseName -Query $sqlStatementBasicRemove -OutputSqlErrors $true
            }
        }


    }
    end {

    }
}
