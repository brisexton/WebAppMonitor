#Requires -RunAsAdministrator
function Uninstall-WAMScheduledTask {

    <#
    .SYNOPSIS
    Removes scheduled task from Task Scheduler.

    .DESCRIPTION


    .PARAMETER TaskName
    Name of scheduled task.

    .EXAMPLE


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Initial
    12/16/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter()]
        [string]$TaskName = 'WebAppMonitor'

    )

    begin {

    }
    process {

        try {
            Write-Verbose -Message "Attempting to find task name $TaskName in Task Scheduler."
            $null = Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop
            Write-Verbose -Message "Found Scheduled Task!"
            Unregister-ScheduledTask -TaskName $TaskName
            Write-Verbose -Message "Successfully Removed scheduled task $TaskName from Task Scheduler."
        } catch {
            Write-Error -Message "Couldn't find scheduled task with name $TaskName in Task Scheduler."
        }

    }
    end {

    }
}
