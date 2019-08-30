Import-Module $PSScriptRoot\..\Module\WAM\WAM.psm1

Test-WAMApps -All | Update-WAMLog | Send-WAMNotification
