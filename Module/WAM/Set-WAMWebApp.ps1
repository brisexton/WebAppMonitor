function Set-WAMWebApp {

    <#
    .SYNOPSIS
    Change Values associated with a Web Application.

    .DESCRIPTION


    .PARAMETER Name
    The Friendly Name of the web application.

    .PARAMETER WebAppId
    The ID number associated with the web application in the database.

    .PARAMETER DatabaseName
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
    Initial
    12/23/2019
    Brian Sexton

#>
    [CmdletBinding(DefaultParameterSetName = "ByName")]
    param(

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByName")]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ById")]
        [ValidateNotNullOrEmpty()]
        [int]$WebAppId,

        [Parameter()]
        [ValidateLength(1, 160)]
        [string]$Description,

        [Parameter()]
        [ValidatePattern("^http")]
        [string]$Url,

        [Parameter()]
        [int]$StatusCode,

        [Parameter()]
        [ValidateSet("GET", "HEAD", "POST", "PUT")]
        [string]$Method,

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

    }
    end {

    }
}
