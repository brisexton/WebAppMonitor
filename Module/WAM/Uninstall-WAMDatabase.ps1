function Uninstall-WAMDatabase {

    <#
    .SYNOPSIS
    Deletes the WAM Database from the Database Server Instance.

    .DESCRIPTION
    This drops the WAM Database after closing all connections.

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
    12/24/2019
    Brian Sexton

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

        $sec = 10
        do {
            Write-Host "The WAM Database will be dropped. You have $sec seconds to abort." -BackgroundColor Green -ForegroundColor White
            $sec -= 1
            Start-Sleep -Seconds 1
        } while ($sec -ne 0)

        $sqlQuerySingleUser = "ALTER DATABASE [$DatabaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE"
        $sqlQueryDropDatabase = "DROP DATABASE [$DatabaseName]"

        if ($PSBoundParameters.ContainsKey("Credential")) {
            try {

                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password

                Write-Verbose "Attempting to connect to server $ServerInstance with specified credential."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $sqlQuerySingleUser -Username $UserName -Password $SQLPass -AbortOnError
                Write-Verbose "Successfully Set database $DatabaseName to single user mode with specified credential."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $sqlQueryDropDatabase -Username $UserName -Password $SQLPass -AbortOnError
                Write-Verbose "Successfully Dropped the database $DatabaseName on Server $SQLInstance with specified credential."
            } catch {
                Write-Host "Failed to Drop Database" -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to connect to server $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $sqlQuerySingleUser -AbortOnError
                Write-Verbose "Successfully Set database $DatabaseName to single user mode."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $sqlQueryDropDatabase -AbortOnError
                Write-Verbose "Successfully Dropped the database $DatabaseName on Server $SQLInstance."
            } catch {
                Write-Host "Failed to Drop Database" -ForegroundColor Red
                $Error[0]
            }
        }

    }
    end {

    }
}
