#Requires -RunAsAdministrator
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

    .PARAMETER TaskType
    NOT YET IMPLEMENTED!! This is to used for specifying whether to use
    ScheduledJobs or ScheduledTasks. Currently it's using ScheduledTasks.

    .PARAMETER Credential
    Local User Credential on the server for the scheduled task to run as.

    .EXAMPLE
    $cred = Get-Credential -Message "Enter Local User Creds"
    Install-WAMScheduledTask -RuntimeFrequency 120 -InstallLocation C:\scripts\WAM -Credential $cred

    This will set the scheduled task to execute every 2 minutes (120 seconds) with
    the WAM folder located in C:\scripts

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
        [ValidateSet('ScheduledTask', 'ScheduledJobs')]
        [string]$TaskType,

        [Parameter(Mandatory)]
        [pscredential]$Credential

    )

    begin {

    }
    process {

        $ExecutionFrequency = New-TimeSpan -Seconds $RuntimeFrequency

        $TaskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval $ExecutionFrequency
        $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable -Compatibility Win8 -ExecutionTimeLimit $ExecutionFrequency
        $TaskAction = New-ScheduledTaskAction –Execute "Powershell.exe" -Argument `"$ScriptFilePath`" -WorkingDirectory $ModuleLocation

        $username = $Credential.UserName
        $password = $Credential.GetNetworkCredential().Password

        Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -RunLevel Highest -User $username -Password $password -Settings $TaskSettings

    }
    end {

    }

}
