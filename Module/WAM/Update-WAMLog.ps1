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
    param(

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [pscustomObject]$TestResultObj,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [int]$WebAppId,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [datetime]$StartTime,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [datetime]$EndTime,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
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
            $StartTime = $TestResultObj.StartTime
            $EndTime = $TestResultObj.EndTime
            if ($TestResultObj.TestResultIsFailure) {
                $TestResult = 1
            } else {
                $TestResult = 0
            }

        }


        if ($PSCmdlet.ParameterSetName -eq 'ById') {
            if ($Faliure) {
                $TestResult = 1
            } else {
                $TestResult = 0
            }

        }

        $AppTestResults = @"
            INSERT INTO dbo.webapps
                (webapp_id, start_time, end_time, failure)
            VALUES
              ($WebAppId, $StartTime, $EndTime, $Failure)
"@

        if ($PSBoundParameters.ContainsKey("Credential")) {

            $SQLLoginUserName = $Credential.UserName
            $SQLLoginPassword = $Credential.GetNetworkCredential().Password

            try {
                Write-Verbose "Attempting to add information for app id $WebAppId to the database $DatabaseName on SQL Server $ServerInstance with the credentials specified."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestResults -Username $SQLLoginUserName -Password $SQLLoginPassword -AbortOnError
                Write-Verbose "Successfully saved information for app id $WebAppId to the $DatabaseName on Server $ServerInstance with the credentials specified."
            } catch {
                Write-Host "Failed to add test results to the database with specified credentials." -ForegroundColor Red
                $Error[0]
            }
        } else {

            try {
                Write-Verbose "Attempting to add information for app id $WebAppId to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestResults -ErrorAction Stop
                Write-Verbose "Successfully saved information app id $WebAppId to the $DatabaseName on Server $ServerInstance"
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
            } catch {
                Write-Host "Failed to add test results to the database." -ForegroundColor Red
                $Error[0]
            }
        }



    }

    end {
    }
}
