#requires -modules SqlServer
<#

    WebAppMonitor PowerShell Module





#>
Import-Module SqlServer

. $PSScriptRoot\Install-WAMDatabase.ps1
. $PSScriptRoot\Get-WAMWebApp.ps1
. $PSScriptRoot\New-WAMWebApp.ps1
. $PSScriptRoot\Set-WAMWebApp.ps1
. $PSScriptRoot\Remove-WAMWebApp.ps1
. $PSScriptRoot\Test-WAMApps.ps1
. $PSScriptRoot\Update-WAMLog.ps1
. $PSScriptRoot\Send-WAMNotification.ps1
. $PSScriptRoot\Register-WAMScheduledTask.ps1
