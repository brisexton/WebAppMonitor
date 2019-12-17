$BasePath = "C:\Users\bsexton\Workspaces\PowerShell\Repository\WebAppMonitor"

Set-Location -Path $BasePath

Import-Module .\Module\WAM\WAM.psm1 -Verbose

# install database
Install-WAMDatabase

# Add Web application to be monitored
New-WAMWebApp -Name "CNN.com" -Description "Sample website to make sure it's working correctly" -Url "https://www.cnn.com" -StatusCode 200 -Method GET -ServerInstance DEVLT003-VH\DEV

# Add notification system for alerts
New-WAMNotificationSystem


# add notification address for alerts



# create local user account to run the scheduled task as
$RunAsUserName = "WAMUser"
$RunAsUserPassword = ConvertTo-SecureString -String 'TH1s1snt@S3curePassw0rd' -AsPlainText -Force

$LocalUserInfo = @{
    Name = $RunAsUserName
    Description = "RunAs account for WebAppMonitor Scheduled Task for Web Application Monitoring."
    Password = $RunAsUserPassword
    AccountNeverExpires = $true
    ChangePasswordAtNextLogon = $false
    PasswordNeverExpires = $true
}

New-LocalUser @LocalUserInfo

# add as scheduled task

$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $RunAsUserName,$RunAsUserPassword

Install-WAMScheduledTask -RuntimeFrequency 120 -InstallLocation C:\scripts -ScriptFilePath C:\scripts\WAMRuntime.ps1 -Credential $cred

