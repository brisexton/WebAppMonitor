function New-WAMWebApp {
    <#
    .SYNOPSIS
    Adds a URL to the database to be monitored.

    .DESCRIPTION


    .PARAMETER Url
    The URL to monitor.

    .PARAMETER StatusCode
    The HTTP status code that should be returned.

    .PARAMETER IsMonitored
    Set's the URL If you want set the URL to be monitored. Use this switch.

    .PARAMETER Database
    The name of the database used by WebAppMonitor. The default value is
    WebAppMonitor.

    .PARAMETER ServerInstance
    The Instance of SQL Server where the database is located.

    .PARAMETER Credential
    A SQL Login to connect to the database engine and write information.


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Update
    11/10/2019
    Brian Sexton

    Initial
    8/20/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [ValidateLength(1, 50)]
        [string]$Name,

        [Parameter()]
        [ValidateLength(1, 160)]
        [string]$Description,

        [Parameter(Mandatory)]
        [ValidatePattern("^http")]
        [string]$Url,

        [Parameter(Mandatory)]
        [int]$StatusCode,

        [Parameter()]
        [ValidateSet("GET", "HEAD", "POST", "PUT", "TRACE")]
        [string]$Method = "GET",

        [Parameter()]
        [string]$ContentType,

        [Parameter()]
        [string]$PostBody,

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



        if ($PSBoundParameters.ContainsKey($IsMonitored)) {
            $MonitorState = 1
        } else {
            $MonitorState = 0
        }

        $BasicAppInfo = @"
    INSERT INTO dbo.webapps
        (name, description, uri, monitor_active)
     VALUES
        ($Name, $Description, `'$Url`', $MonitorState)
"@

        $AppTestInfo = @"
    INSERT INTO dbo.apptests
        (webapp_id, status_code, method, post_body)
     VALUES
        ($webappid, $StatusCode, $Method, $PostBody)
"@

        if ($PSBoundParameters.ContainsKey($Credential)) {

            try {
                Write-Verbose "Attempting to add information for $Name to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $BasicAppInfo -Credential $Credential -ErrorAction Stop
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
                [int]$webappId = Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'webapps' -SchemaName dbo -Credential $Credential | Where-Object { $_.Name -eq $Name }
                Write-Verbose "Attempting to save expected test results for web app $Name"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestInfo -Credential $Credential -ErrorAction Stop
            } catch {
                Write-Host "Failed to add Web App $Name to the database" -ForegroundColor Red
                $Error[0]
            }
        } else {

            try {
                Write-Verbose "Attempting to add information for $Name to the database $DatabaseName on SQL Server $ServerInstance."
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $BasicAppInfo -ErrorAction Stop
                Write-Verbose "Retrieving the webapp id from $DatabaseName for webapp $Name"
                [int]$webappId = Read-SqlTableData -ServerInstance $ServerInstance -DatabaseName $DatabaseName -TableName 'webapps' -SchemaName dbo | Where-Object { $_.Name -eq $Name }
                Write-Verbose "Attempting to save expected test results for web app $Name"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $AppTestInfo -ErrorAction Stop
            } catch {
                Write-Host "Failed to add Web App $Name to the database" -ForegroundColor Red
                $Error[0]
            }
        }





    }
    end {

    }

}
