#requires -Version 4.0
function Install-WAMDatabase {
    <#
    .SYNOPSIS
    Creates the database for WebAppMonitor.

    .DESCRIPTION
    Executes SQL Queries to setup the database. This cmdlet requires either
    SqlServer or SQLPS.

    .PARAMETER ServerInstance
    Default value is is localhost

    .PARAMETER DatabaseName
    Name of the SQL Database to be created. The default value is WebAppMonitor.

    .PARAMETER Credential
    SQL Login to connect to the Database Engine to create the Database.

    .EXAMPLE
    Install-WAMDatabase

    Creates database and tables on local default instance using Windows Authentication.

    .EXAMPLE
    $sqlCreds = Get-Credential
    Install-WAMDatabase -ServerInstance 'SERVER1\INSTANCE1' -Credential $sqlCreds

    This creates the database with the default name of WebAppMonitor and tables
    on SQL Server Instance SERVER1\INSTANCE1 and connects with $sqlCreds


    .INPUTS


    .OUTPUTS


    .LINK


    .NOTES
    Initial
    8/19/2019
    Brian Sexton

#>
    [CmdletBinding()]
    param(

        [Parameter()]
        [ValidateNotNullorEmpty()]
        [string]$ServerInstance = $env:COMPUTERNAME,

        [Parameter()]
        [ValidateNotNullorEmpty()]
        [string]$DatabaseName = "WebAppMonitor",

        [Parameter()]
        [ValidateNotNullorEmpty()]
        [pscredential]$Credential
    )

    begin {

    }
    process {

        $NewDatabaseStatement = "CREATE DATABASE $DatabaseName"

        $NewDatabaseTables = @"
        USE [WebAppMonitor]
        GO

        CREATE TABLE [dbo].[webapps](
            [webapp_id] [int] IDENTITY(1,1) NOT NULL,
            [name] [nvarchar](50) NOT NULL,
            [description] [nvarchar](160) NULL,
            [uri] [nvarchar](160) NOT NULL,
            [monitor_active] [bit] NOT NULL
        ) ON [PRIMARY]
        GO

        CREATE TABLE [dbo].[headers](
            [webapp_id] [int] NOT NULL,
            [header_key] [nvarchar](100) NULL,
            [header_value] [nvarchar](100) NULL
        )
        GO

        CREATE TABLE [dbo].[apptests](
            [test_id] [int] IDENTITY(1,1) NOT NULL,
            [webapp_id] [int] NOT NULL,
            [status_code] [int] NOT NULL,
            [method] [char](7) NOT NULL,
            [post_body] [text] NULL
        ) ON [PRIMARY]
        GO

        CREATE TABLE [dbo].[apptestresults](
            [webapp_id] [int] NOT NULL,
            [start_time] [smalldatetime] NOT NULL,
            [end_time] [smalldatetime] NULL,
            [failure] [bit] NOT NULL
        )
        GO

        CREATE TABLE [dbo].[notificationsystem](
            [notifysystem_id] [int] IDENTITY(1,1) NOT NULL,
            [notifysystem_type] [nvarchar](10) NOT NULL,
            [notifysystem_name] [nvarchar](20) NOT NULL,
            [notifysystem_description] [nvarchar](100) NULL
        ) ON [PRIMARY]
        GO

        CREATE TABLE [dbo].[notificationtype](
            [notifytype_id] [int] IDENTITY(1,1) NOT NULL,
            [notifytype_name] [nvarchar](10) NOT NULL,
            [notifytype_description] [nvarchar](100) NOT NULL
        ) ON [PRIMARY]
        GO

        INSERT INTO [dbo].[notificationtype](notifytype_name, notifytype_description)
        VALUES ('Email', 'SMTP Server Relay')

        INSERT INTO [dbo].[notificationtype] (notifytype_name, notifytype_description)
        VALUES ('SMS', 'Text Messages')

        CREATE TABLE [dbo].[notification](
            [notification_id] [int] IDENTITY(1,1) NOT NULL,
            [webapp_id] [int] NOT NULL,
            [notifyee_id] [int] NOT NULL,
            [notification_subject] [nvarchar](100) NULL,
            [notification_message] [nvarchar](max) NULL
        ) ON [PRIMARY]
        GO

        CREATE TABLE [dbo].[emailconfig]
        (
            [emailsettings_id] [int] IDENTITY(1,1) NOT NULL,
            [notifysystem_id] [int] NOT NULL,
            [from_name] [nvarchar] (50) NOT NULL,
            [from_address] [nvarchar](50) NOT NULL,
            [servername] [nvarchar](100) NOT NULL,
            [smtpserver_username] [nvarchar](50) NULL,
	        [smtpserver_password] [nvarchar](50) NULL,
            [port] [int] NOT NULL,
            [usessl] [bit] NOT NULL
        )
        GO

        CREATE TABLE [dbo].[notifyee]
        (
            [notification_id] [int] IDENTITY(1,1) NOT NULL,
            [notifysystem_id] [int] NULL,
            [notification_targetname] [nvarchar](50) NULL,
            [notification_targetaddress] [nvarchar](100) NULL,
            [notification_targetdescription] [nvarchar](150) NULL,
            [notification_systemtype] [int] NOT NULL,
            [enabled] [bit] NOT NULL
        ) ON [PRIMARY]
        GO

        CREATE VIEW [dbo].[appinfo]
            AS
                SELECT dbo.webapps.*, dbo.apptests.status_code, dbo.apptests.method, dbo.apptests.post_body
                FROM dbo.webapps INNER JOIN
                    dbo.apptests ON dbo.webapps.webapp_id = dbo.apptests.webapp_id
        GO

        CREATE VIEW [dbo].[smtpconfiguration]
            AS
                SELECT        dbo.emailconfig.emailsettings_id, dbo.notificationsystem.notifysystem_name, dbo.notificationsystem.notifysystem_description, dbo.emailconfig.from_name, dbo.emailconfig.from_address, dbo.emailconfig.servername,
                                 dbo.emailconfig.smtpserver_username, dbo.emailconfig.smtpserver_password, dbo.emailconfig.port, dbo.emailconfig.usessl
                FROM            dbo.notificationsystem INNER JOIN
                                 dbo.emailconfig ON dbo.notificationsystem.notifysystem_id = dbo.emailconfig.notifysystem_id
                WHERE        (dbo.notificationsystem.notifysystem_type = N'Email')
        GO
"@

        if ($PSBoundParameters.ContainsKey("Credential")) {

            $UserName = $Credential.UserName
            $SQLPass = $Credential.GetNetworkCredential().Password

            try {
                Write-Verbose "Attempting to create database $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $NewDatabaseStatement -Username $UserName -Password $SQLPass -AbortOnError

            } catch {
                Write-Host "Failed to Create Database" -ForegroundColor Red
                $Error[0]
            }
            try {
                Write-Verbose "Attempting to create tables in $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $NewDatabaseTables -Username $UserName -Password $SQLPass -AbortOnError
            } catch {
                Write-Host "Failed to Create Database Tables" -ForegroundColor Red
                $Error[0]
            }
        } else {

            try {
                Write-Verbose "Attempting to Create Database $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $NewDatabaseStatement -AbortOnError
            } catch {
                Write-Host "Failed to Create Database" -ForegroundColor Red
                $Error[0]
            }
            try {
                Write-Verbose "Attempting to create tables in $DatabaseName on $ServerInstance"
                Invoke-Sqlcmd -ServerInstance $ServerInstance -Database $DatabaseName -Query $NewDatabaseTables -AbortOnError
            } catch {
                Write-Host "Failed to Create Database Tables" -ForegroundColor Red
                $Error[0]
            }
        }

    }
    end {

    }
}
