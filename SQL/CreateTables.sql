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
    [test_id] [int] NOT NULL,
    [webapp_id] [int] NOT NULL,
    [status_code] [int] NOT NULL,
    [method] [char](7) NOT NULL,
    [post_body] [text] NULL

)
GO

CREATE TABLE [dbo].[apptestresults](
    [webapp_id] [int] NOT NULL,
    [start_time] [datetime] NOT NULL,
    [end_time] [datetime] NULL,
    [failure] [bit] NOT NULL
)

CREATE TABLE [dbo].[notify_type](
    [notifytype_id] [int] NOT NULL,
    [name] [nvarchar](10) NOT NULL,
    [description] [nvarchar](100) NULL
)
GO

CREATE TABLE [dbo].[notification](
    [notification_id] [int] IDENTITY(1,1) NOT NULL,
    [webapp_id] [int] NOT NULL,
    [notification_type] [nvarchar](100) NULL,
    [notification_message] [nvarchar](max) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[emailconfig](
    [emailsettings_id] [int] NOT NULL,
    [from_address] [nvarchar](50) NOT NULL,
    [servername] [nvarchar](100) NOT NULL,
    [port] [int] NOT NULL,
    [usessl] [bit] NOT NULL
)
GO
