function Add-WAMWebApp {
<#
    .SYNOPSIS
    Adds a URL to the

    .DESCRIPTION


    .PARAMETER Url
    The URL to monitor.

    .PARAMETER StatusCode
    The HTTP status code that should be returned.

    .PARAMETER DatabaseInstance
    The Instance of SQL Server where the database is located.

    .PARAMETER Credential
    A SQL Login to connect to the database engine and write information.


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES


#>  [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [string]$Url,



        [Parameter(Mandatory)]
        [int]$StatusCode,

        [Parameter(Mandatory)]
        [string]$DatabaseInstance,

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
Invoke-WebRequest -Uri
