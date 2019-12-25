#requires -modules SqlServer
<#

    WebAppMonitor PowerShell Module





#>

# Creates the database and tables.
. $PSScriptRoot\Install-WAMDatabase.ps1
. $PSScriptRoot\Uninstall-WAMDatabase.ps1
# . $PSScriptRoot\New-WAMSQLLogin.ps1

# Adds a web application, to be monitored, to the database.
. $PSScriptRoot\Get-WAMWebApp.ps1
. $PSScriptRoot\New-WAMWebApp.ps1
. $PSScriptRoot\Set-WAMWebApp.ps1
. $PSScriptRoot\Remove-WAMWebApp.ps1

# Scheduled Task
. $PSScriptRoot\Install-WAMScheduledTask.ps1
. $PSScriptRoot\Uninstall-WAMScheduledTask.ps1

# Configure Notification/Alerting System
. $PSScriptRoot\New-WAMNotificationSystem.ps1
. $PSScriptRoot\Get-WAMNotificationSystem.ps1
. $PSScriptRoot\Set-WAMNotificationSystem.ps1
. $PSScriptRoot\Remove-WAMNotificationSystem.ps1

# Configure Notification/Alert Recipients
. $PSScriptRoot\New-WAMNotification.ps1
. $PSScriptRoot\Set-WAMNotification.ps1
. $PSScriptRoot\Get-WAMNotification.ps1
. $PSScriptRoot\Remove-WAMNotification.ps1
. $PSScriptRoot\Test-WAMNotification.ps1

# Used during routine tests
. $PSScriptRoot\Test-WAMWebApp.ps1
. $PSScriptRoot\Update-WAMLog.ps1
. $PSScriptRoot\Send-WAMNotification.ps1
