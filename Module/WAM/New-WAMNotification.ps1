function New-WAMNotification {

    <#
    .SYNOPSIS
    Adds a notification destination to the database.

    .DESCRIPTION


    .PARAMETER Name
    Friendly name of the alert.

    .PARAMETER Description
    A description or additional information about the alert destination.

    .PARAMETER NotificationType
    This establishes a link between the notification addresse and the
    system to be used for sending the notification/alert.

    .PARAMETER NotificationSystemId

    .PARAMETER Destination

    .PARAMETER WebAppObject


    .PARAMETER WebAppId
    The ID number of the Web Application which is being monitored that you
    want to alert on.

    .PARAMETER WebAppName
    The Name of the Web Application which is being monitored that you
    want to alert on.

    .PARAMETER AllWebApps

    .PARAMETER Enabled


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
    Update
    12/16/2019
    Brian Sexton

    Initial
    11/12/2019
    Brian Sexton

#>
    [CmdletBinding(SupportsShouldProcess)]
    param(

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidateSet('Email', 'SMS')]
        [ValidateNotNullOrEmpty()]
        [string]$NotificationType,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]$NotificationSystemId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ByObject")]
        [ValidateNotNullOrEmpty()]
        [pscustomobject]$WebAppObject,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ById")]
        [ValidateNotNullOrEmpty()]
        [int]$WebAppId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]$WebAppName,

        [Parameter(Mandatory, ParameterSetName = "All")]
        [ValidateNotNullOrEmpty()]
        [switch]$AllWebApps,

        [Parameter()]
        [switch]$Enabled,

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

        switch ($NotificationType) {
            "Email" { $NotificationSystemTypeId = 1; break; }
            "SMS" { $NotificationSystemTypeId = 2; break; }
            default { Write-Host "DEFAULT HIT" -ForegroundColor Red; throw }
        }



        if ($PSBoundParameters.ContainsKey("Enabled")) {
            $Active = 1
        } else {
            $Active = 0
        }



        if ($PSBoundParameters.ContainsKey("Description")) {
            $Description = $Description -replace "'", ""
            $sqlQuery = @"
            INSERT INTO dbo.notifyee
                (notifysystem_id, notification_targetname, notification_targetaddress, notification_targetdescription, notification_systemtype, enabled)
            VALUES
                ($NotificationSystemId, '$Name', '$Destination', '$Description', $NotificationSystemTypeId, $Active)
"@
        } else {
            $sqlQuery = @"
            INSERT INTO dbo.notifyee
                (notifysystem_id, notification_targetname, notification_targetaddress, notification_systemtype, enabled)
            VALUES
                ($NotificationSystemId, '$Name', '$Destination', $NotificationSystemTypeId, $Active)
"@
        }

        $sqlQueryCheckExisting = "SELECT [notification_id], [notification_targetaddress] FROM [dbo].[notifyee] WHERE notification_targetaddress LIKE '%$Destination%'"

        if ($PSBoundParameters.ContainsKey("Credential")) {
            $SQLLoginUserName = $Credential.UserName
            $SQLLoginPassword = $Credential.GetNetworkCredential().Password

            try {
                Write-Verbose "Checking for existing target address named $Destination in the $DatabaseName database on $ServerInstance with specified credentials."
                $Result = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                if ($Result.Count -ige 1) {
                    Write-Host "The target address $Destination already exists in the database."
                    throw;
                }
            } catch {
                $Error[0]
                throw;
            }

        } else {
            try {
                Write-Verbose "Checking for existing target address named $Destination in the $DatabaseName database on $ServerInstance with specified credentials."
                $Result = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                if ($Result.Count -ige 1) {
                    Write-Host "The target address $Destination already exists in the database."
                    throw;
                }
            } catch {
                $Error[0]
                throw;
            }
        }


        if ($PSBoundParameters.ContainsKey("Credential")) {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to Execute Query with specified credential."
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."
                $notifyeeId = [int](Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQueryCheckExisting -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError).notification_id
                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to retrieve the NotifyeeID with specified credential."
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -OutputAs DataRows -AbortOnError
                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to insert data."
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                $notifyeeId = [int](Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQueryCheckExisting -OutputAs DataRows -AbortOnError).notification_id
                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to retrieve the NotifyeeID."
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        }

        switch ($PSCmdlet.ParameterSetName) {
            "ByObject" {
                $WebAppId = $WebAppObject.WebAppId
                $sqlQuery = "INSERT INTO dbo.notificationalerts (webapp_id, notifyee_id) VALUES ( $WebAppId, $notifyeeId )"
            }
            "ById" {


            }
            "ByName" {
                $sqlQuery = "SELECT * FROM [dbo].[webapps] WHERE name LIKE %$Name%"
            }
            "All" { $sqlQuery = 'SELECT * FROM [dbo].[webapps]'; break; }
            default { Write-Host "DEFAULT HIT" -ForegroundColor Red; throw }
        }

        if ($PSBoundParameters.ContainsKey("Credential")) {

            try {

                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."

                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to Execute Query with specified credential."



            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"

                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to insert data."
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        }


    }
    end {

    }
}
