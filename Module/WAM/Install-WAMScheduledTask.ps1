#requires -RunAsAdministrator
function Install-WAMScheduledTask {

    <#
    .SYNOPSIS
    Registers a Scheduled Task in Task Scheduler to execute a script.

    .DESCRIPTION


    .PARAMETER TaskName
    This is the name of the Scheduled Task that appears in Task Scheduler. The
    default value is WebAppMonitor.

    .PARAMETER RuntimeFrequency
    How often the scheduled task should run in seconds.

    .PARAMETER ModuleLocation
    The full path to where the WAM folder is located. This is used to specify
    the working directory for the Scheduled Task.

    .PARAMETER ScriptFilePath
    Full path to the script which contains all commands for automated runs.

    .PARAMETER PowerShellVersion
    NOT YET IMPLEMENTED - Valid options are WindowsPowerShell or PowerShellCore.
    By specifiying what PS Host you want to use, this changes whether the scheduled
    task get executed under Powershell.exe or pwsh.exe

    .PARAMETER TaskType
    NOT YET IMPLEMENTED - This is to used for specifying whether to use
    ScheduledJobs or ScheduledTasks. Currently it's using ScheduledTasks.

    .PARAMETER Credential
    Local User Credential on the server for the scheduled task to run as.

    .EXAMPLE
    $cred = Get-Credential -Message "Enter Local User Creds for unattended runs."
    Install-WAMScheduledTask -RuntimeFrequency 120 -ScriptFilePath C:\scripts\WAMRuntime.ps1 -InstallLocation C:\scripts\WAM -Credential $cred

    This will set the scheduled task to execute every 2 minutes (120 seconds) with
    the WAM PowerShell Module folder located in C:\scripts with the Runtime Script.

    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Update
    12/16/2019
    Brian Sexton

    Initial
    8/19/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param (

        [Parameter()]
        [string]$TaskName = "WebAppMonitor",

        [Parameter(Mandatory)]
        [int]$RuntimeFrequency = 60,

        [Parameter(Mandatory)]
        [string]$ModuleLocation,

        [Parameter(Mandatory)]
        [string]$ScriptFilePath,

        [Parameter()]
        [ValidateSet('WindowsPowerShell', 'PowerShellCore')]
        [string]$PowerShellVersion,

        [Parameter()]
        [ValidateSet('ScheduledTasks', 'ScheduledJobs')]
        [string]$TaskType,

        [Parameter()]
        [pscredential]$Credential

    )

    begin {

    }
    process {

        $ExecutionFrequency = New-TimeSpan -Seconds $RuntimeFrequency

        if (($PSBoundParameters.ContainsKey("PowerShellVersion"))) {
            switch ($PowerShellVersion) {
                "WindowsPowerShell" { $psshellexecutable = "Powershell.exe"; break }
                "PowerShellCore" { $psshellexecutable = "pwsh.exe"; break }
                default { break }
            }
        }

        $psshellexecutable = "Powershell.exe"

        $TaskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval $ExecutionFrequency
        $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Compatibility Win8 -RunOnlyIfNetworkAvailable -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit $ExecutionFrequency
        $TaskAction = New-ScheduledTaskAction -Execute $psshellexecutable -Argument `"$ScriptFilePath`" -WorkingDirectory `"$ModuleLocation`"

        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password

        Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -RunLevel Highest -User $username -Password $password -Settings $TaskSettings

    }
    end {

    }

}
