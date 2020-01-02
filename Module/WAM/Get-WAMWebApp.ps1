function Get-WAMWebApp {
    <#
    .SYNOPSIS
    Retrieve's Web Applications in the database

    .DESCRIPTION


    .PARAMETER Name
    The name of the Web Application that has been registered. This value
    get's submitted to the database as a wild card.

    .PARAMETER IsMonitored
    Whether the App is set to be actively monitored.

    .PARAMETER DatabaseName
    The name of the database used by WebAppMonitor. The default value is
    WebAppMonitor.

    .PARAMETER ServerInstance
    The Instance of SQL Server where the database is located.

    .PARAMETER Credential
    SQL Login credentials to connect to the SQL Server Instance.


    .EXAMPLE
    Get-WAMWebApp -Name "cnn" -ServerInstance "SERVER1\SQL"

    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Update
    12/23/2019
    Brian Sexton

    Initial
    11/10/2019
    Brian Sexton

#>
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    [OutputType([PSCustomObject])]
    param(

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByName")]
        [string]$Name,

        [Parameter()]
        [switch]$IsMonitored,

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


        $sqlQuery = 'SELECT * FROM [dbo].[appinfo]'

        if ($PSBoundParameters.ContainsKey("IsMonitored")) {
            $sqlQuery = 'SELECT * FROM [dbo].[appinfo] WHERE monitor_active = 1'
        }
        if ($PSBoundParameters.ContainsKey("Name")) {
            $sqlQuery = "SELECT * FROM [dbo].[appinfo] WHERE name LIKE `'%$Name%`'"
        }


        Write-Verbose "Will attempt to execute query $sqlQuery"

        if ($PSBoundParameters.ContainsKey("Credential")) {
            try {

                $UserName = $Credential.UserName
                $SQLPass = $Credential.GetNetworkCredential().Password

                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with specified credential."
                $Output = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -Username $UserName -Password $SQLPass -Credential $Credential -OutputAs DataRows -AbortOnError
                foreach ($row in $Output) {
                    $obj = New-Object PSCustomObject -Property ([ordered] @{
                            WebAppId      = [int]$row.webapp_id
                            Name          = [string]$row.name
                            Description   = [string]$row.description
                            Uri           = [string]$row.uri
                            Method        = [string]$row.Method
                            StatusCode    = [int]$row.status_code
                            PostBody      = [string]$row.post_body
                            MonitorActive = [bool]$row.monitor_active
                        })
                    Write-Output $obj
                }
                Write-Verbose "Successfully Connected to Database $DatabaseName on Server $SQLInstance to Execute Query with specified credential."
            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        } else {
            try {
                Write-Verbose "Attempting to connect to database $DatabaseName on server $ServerInstance with Windows Authentication"
                $Output = Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $sqlQuery -OutputAs DataRows -AbortOnError
                foreach ($row in $Output) {
                    $obj = New-Object PSCustomObject -Property ([ordered] @{
                            WebAppId      = [int]$row.webapp_id
                            Name          = [string]$row.name
                            Description   = [string]$row.description
                            Uri           = [string]$row.uri
                            Method        = [string]$row.Method
                            StatusCode    = [int]$row.status_code
                            PostBody      = [string]$row.post_body
                            MonitorActive = [bool]$row.monitor_active
                        })
                    Write-Output $obj
                }

            } catch {
                Write-Host "Failed to Execute Query" -ForegroundColor Red
                $Error[0]
            }
        }



    }
    end {

    }
}
