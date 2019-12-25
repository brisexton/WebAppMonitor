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
        [string]$ServerInstance = $env:COMPUTERNAME,

        [Parameter()]
        [string]$DatabaseName = "WebAppMonitor",

        [Parameter()]
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
            [start_time] [datetime] NOT NULL,
            [end_time] [datetime] NULL,
            [failure] [bit] NOT NULL
        )
        GO

        CREATE TABLE [dbo].[notify_type](
            [notifytype_id] [int] NOT NULL,
            [name] [nvarchar](10) NOT NULL,
            [description] [nvarchar](100) NULL
        )
        GO

        INSERT INTO [dbo].[notify_type](notifytype_id, name, description)
        VALUES (1, 'Email', 'SMTP Server Relay')

        INSERT INTO [dbo].[notify_type] (notifytype_id, name, description)
        VALUES (2, 'SMS', 'Text Messages')

        CREATE TABLE [dbo].[notification](
            [notification_id] [int] IDENTITY(1,1) NOT NULL,
            [webapp_id] [int] NOT NULL,
            [notification_type] [nvarchar](100) NULL,
            [notification_message] [nvarchar](max) NULL
        ) ON [PRIMARY]
        GO

        CREATE TABLE [dbo].[emailconfig]
        (
            [emailsettings_id] [int] IDENTITY(1,1) NOT NULL,
            [from_name] [nvarchar] (50) NOT NULL,
            [from_address] [nvarchar](50) NOT NULL,
            [servername] [nvarchar](100) NOT NULL,
            [smtpserver_username] [nvarchar](50) NULL,
	        [smtpserver_password] [nvarchar](50) NULL,
            [port] [int] NOT NULL,
            [usessl] [bit] NOT NULL
        ) ON [PRIMARY]
        GO

        CREATE VIEW [dbo].[appinfo]
            AS
                SELECT dbo.webapps.*, dbo.apptests.status_code, dbo.apptests.method, dbo.apptests.post_body
                FROM dbo.webapps INNER JOIN
                    dbo.apptests ON dbo.webapps.webapp_id = dbo.apptests.webapp_id
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
