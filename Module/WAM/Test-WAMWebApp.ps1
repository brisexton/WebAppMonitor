function Test-WAMWebApp {
    <#
    .SYNOPSIS
    Runs tests against the URL's provided.

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

    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Update
    1/2/2020
    Brian Sexton

    Initial
    12/27/2019
    Brian Sexton


#>
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    [OutputType([PSCustomObject])]
    param (

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByObject')]
        [ValidateNotNullOrEmpty()]
        [pscustomObject]$WebAppObject,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [int]$WebAppId,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [string]$Uri,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [string]$Method,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateNotNullOrEmpty()]
        [int]$StatusCode

    )

    begin {

    }

    process {


        $StartTime = [datetime](Get-Date)

        If ($PSCmdlet.ParameterSetName -eq 'ByObject') {
            $ExpectedReturnStatusCode = $WebAppObject.StatusCode
            $WebAppId = $WebAppObject.WebAppId
            $Request = Invoke-WebRequest -Uri $WebAppObject.Uri -Method $WebAppObject.Method

        }

        if ($PSCmdlet.ParameterSetName -eq 'ById') {
            $ExpectedReturnStatusCode = $StatusCode
            $Request = Invoke-WebRequest -Uri $Uri -Method $Method
        }

        If ($Request.StatusCode -eq $ExpectedReturnStatusCode) {
            $TestResultIsFailure = $false
        } else {
            $TestResultIsFailure = $true
        }

        $EndTime = [datetime](Get-Date)

        $obj = New-Object -TypeName PSCustomObject -Property ([ordered] @{
                WebAppId           = $WebAppId
                ExpectedStatusCode = $ExpectedReturnStatusCode
                ReturnedStatusCode = $Request.StatusCode
                StartTime          = $StartTime
                EndTime            = $EndTime
                Failure            = $TestResultIsFailure
            })

        Write-Output $obj


    }

    end {
    }
}
