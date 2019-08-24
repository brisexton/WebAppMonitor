
function Test-WAMApps.ps1 {
<#
    .SYNOPSIS
    Runs tests against the URL's provided.

    .DESCRIPTION


    .PARAMETER


    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES


#>
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
    }

    end {
    }
}
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

        $headers.Add("$HeaderKey", "$HeaderValue")

        $headers.Add("X-Cisco-Meraki-API-Key", "$APIKey")
        $headers.Add("Content-Type", "application/json")

        Invoke-RestMethod -uri $uri -Method Get -Headers $headers
