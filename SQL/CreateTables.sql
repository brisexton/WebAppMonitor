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
    [header_key] [nvarchar(100)] NULL,
    [header_value] [nvarchar(100)] NULL
)

CREATE TABLE [dbo].[apptests](

)


CREATE TABLE [dbo].[notification](
    [webapp_id] [int] NOT NULL,
    [header_key] [nvarchar(100)] NULL,
    [header_value] [nvarchar(100)] NULL
)

CREATE TABLE [dbo].[config](
    [webapp_id] [int] NOT NULL,
    [header_key] [nvarchar(100)] NULL,
    [header_value] [nvarchar(100)] NULL
)

CREATE TABLE [dbo].[configkey](
    [webapp_id] [int] NOT NULL,
    [header_key] [nvarchar(100)] NULL,
    [header_value] [nvarchar(100)] NULL
)
