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

        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]$TestResultObj,

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

        if ($TestResultObj.Failure) {

            $WebAppId = $TestResultObj.WebAppId
            $TestStartTime = $TestResultObj.StartTime
            $TestEndTime = $TestResultObj.EndTime


            if ($PSBoundParameters.ContainsKey("Credential")) {
                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password
            }

            $sqlQuery = "SELECT [webapp_id], [notifyee_id] FROM notificationalerts WHERE webapp_id = $WebAppId"

            if ($PSBoundParameters.ContainsKey("Credential")) {

                $SQLLoginUserName = $Credential.UserName
                $SQLLoginPassword = $Credential.GetNetworkCredential().Password

                try {
                    Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."
                    $NotifyeeIdsObj = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                    Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to Execute Query with specified credential."
                } catch {
                    Write-Host "Failed to Execute Query" -ForegroundColor Red
                    $Error[0]
                }

            } else {

                try {
                    Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                    $NotifyeeIdsObj = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -OutputAs DataRows -AbortOnError
                } catch {
                    Write-Host "Failed to Execute Query" -ForegroundColor Red
                    $Error[0]
                }
            }

            Foreach ($Nid in $NotifyeeIdsObj) {
                $RecipientId = $Nid.notifyee_id

                $sqlQuery = @"
                SELECT        dbo.notifyee.*, dbo.emailconfig.*, dbo.notificationalerts.webapp_id, dbo.notificationalerts.notifyee_id
                FROM            dbo.notifyee INNER JOIN
                         dbo.emailconfig ON dbo.notifyee.notifysystem_id = dbo.emailconfig.notifysystem_id INNER JOIN
                         dbo.notificationalerts ON dbo.notifyee.notification_id = dbo.notificationalerts.notifyee_id CROSS JOIN
                         dbo.notificationsystem
                WHERE        (dbo.notificationalerts.notifyee_id = 1)
"@
                if ($PSBoundParameters.ContainsKey("Credential")) {

                    try {
                        Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."
                        $AlertRecipientsObj = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $SQLLoginUserName -Password $SQLLoginPassword -OutputAs DataRows -AbortOnError
                        Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to Execute Query with specified credential."
                    } catch {
                        Write-Host "Failed to Execute Query" -ForegroundColor Red
                        $Error[0]
                    }

                } else {

                    try {
                        Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                        $AlertRecipientsObj = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -OutputAs DataRows -AbortOnError
                    } catch {
                        Write-Host "Failed to Execute Query" -ForegroundColor Red
                        $Error[0]
                    }

                }

            }

            $FromFullAddress = "$FromName <$FromAddress>"

            foreach ($EmailDestination in $EmailDestinations) {
                Send-MailMessage -To "$EmailDestination" -From $FromFullAddress -Body $MessageBody -BodyAsHtml -Priority High -SmtpServer $SMTPServer -Port $SMTPPort -Credential $SMTPCredentail -UseSsl
            }


        }
    }
    end {
    }
}
