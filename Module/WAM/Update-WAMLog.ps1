function Update-WAMLog {
    <#
    .SYNOPSIS
    Saves Test information to the Dataabse.

    .DESCRIPTION


    .PARAMETER WebAppObject
    An object which includes all of the Web App info to run tests against.

    .PARAMETER WebAppId
    The id of the WebApp as it's known in the database.

    .PARAMETER Uri
    The Uri to run the tests against.

    .PARAMETER Method
    The HTTP verb which shall be invoked against the Uri.

    .PARAMETER StatusCode
    The status code that should be returned by the HTTP server.

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
    Intiial
    1/2/2020
    Brian Sexton

#>
    [CmdletBinding(DefaultParameterSetName = 'ByObject')]
    [OutputType([PSCustomObject])]
    param(

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [pscustomObject]$TestResultObj,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [int]$WebAppId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTime,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [datetime]$EndTime,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [bool]$Failure,

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




        If ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $WebAppId = $TestResultObj.WebAppId
            [string]$StartTime = "{0:yyyy-MM-dd HH:mm:ss}" -f $TestResultObj.StartTime
            [string]$EndTime = "{0:yyyy-MM-dd HH:mm:ss}" -f $TestResultObj.EndTime
            if ($TestResultObj.Failure) {
                $TestResult = 1
            } else {
                $TestResult = 0
            }
        }


        if ($PSCmdlet.ParameterSetName -eq 'ById') {
            [string]$StartTime = "{0:yyyy-MM-dd HH:mm:ss}" -f $StartTime
            [string]$EndTime = "{0:yyyy-MM-dd HH:mm:ss}" -f $EndTime

            if ($Faliure) {
                $TestResult = 1
            } else {
                $TestResult = 0
            }
        }

        $AppTestResults = @"
            INSERT INTO dbo.apptestresults
                (webapp_id, start_time, end_time, failure)
            VALUES
              ($WebAppId, '$StartTime', '$EndTime', $TestResult)
"@

        if ($PSBoundParameters.ContainsKey("Credential")) {

            $SQLLoginUserName = $Credential.UserName
            $SQLLoginPassword = $Credential.GetNetworkCredential().Password

            try {
                Write-Verbose "Attempting to add information for app id $WebAppId to the database $DatabaseName on SQL Server $ServerInstance with the credentials specified."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestResults -Username $SQLLoginUserName -Password $SQLLoginPassword -AbortOnError
                Write-Verbose "Successfully saved information for app id $WebAppId to the $DatabaseName on Server $ServerInstance with the credentials specified."
                $LoggedToDatabase = $true
            } catch {
                $LoggedToDatabase = $false
                Write-Host "Failed to add test results to the database with specified credentials." -ForegroundColor Red
                $Error[0]
            }
        } else {

            try {
                Write-Verbose "Attempting to add information for app id $WebAppId to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestResults -AbortOnError
                Write-Verbose "Successfully saved information app id $WebAppId to the $DatabaseName on Server $ServerInstance"
                $LoggedToDatabase = $true
            } catch {
                $LoggedToDatabase = $false
                Write-Host "Failed to add test results to the database." -ForegroundColor Red
                $Error[0]
            }
        }
        $obj = New-Object -TypeName PSCustomObject -Property ([ordered]@{
                WebAppId  = $WebAppId
                StartTime = $StartTime
                EndTime   = $EndTime
                Failure   = [bool]$TestResult
            })
        Write-Output $obj
    }
    end {
    }
}
