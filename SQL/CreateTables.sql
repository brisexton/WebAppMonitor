USE [WebAppMontior]
GO


CREATE TABLE [dbo].[webapps](
	[webapp_id] [int] IDENTITY(1,1) NOT NULL,
    [name] [nvarchar(50)] NOT NULL,
    [description] [nvarchar(160)] NULL,
	[uri] [nvarchar(160)] NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[headers](
    [webapp_id] [int] NOT NULL,
    [order] [int] NULL,
    [header_key] [nvarchar(100)] NULL,
    [header_value] [nvarchar(100)] NULL
)
GO


CREATE TABLE [dbo].[apptests](
    [test_id] [int] NOT NULL,
    [webapp_id] [int] NOT NULL,
    [status_code] [int] NOT NULL,
)
GO

CREATE TABLE [dbo].[notify_type](
    [notifytype_id] [int] NOT NULL,
    [name] [nvarchar(10)] NOT NULL,
    [description] [nvarchar(100)] NULL
)
GO

CREATE TABLE [dbo].[notification](
    [webapp_id] [int] NOT NULL,
    [notification_type] [nvarchar(100)] NULL,
    [notification_message] [nvarchar(100)] NULL
)
GO

CREATE TABLE [dbo].[emailconfig](
    [emailsettings_id] [int] NOT NULL,
    [port] [int] NULL,
    [header_value] [nvarchar(100)] NULL
)
GO
