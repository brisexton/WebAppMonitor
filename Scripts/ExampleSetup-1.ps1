$BasePath = "C:\Users\bsexton\Workspaces\PowerShell\Repository\WebAppMonitor"

Set-Location -Path $BasePath

Import-Module .\Module\WAM\WAM.psm1 -Verbose

# install database
Install-WAMDatabase

# Add Web application to be monitored
New-WAMWebApp -Name "CNN.com" -Description "Sample website to make sure it's working correctly" -Url "https://www.cnn.com" -StatusCode 200 -Method GET -ServerInstance DEVLT003-VH\DEV


# Add notification system for alerts



# add notification address for alerts


# add as scheduled task
$cred = Get-Credential -Message "Enter Credentials to run scheduled task as"
Install-WAMScheduledTask -RuntimeFrequency 120 -InstallLocation C:\scripts -ScriptFilePath C:\scripts\WAMRuntime.ps1 -Credential $cred

