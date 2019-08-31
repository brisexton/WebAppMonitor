/* Drop database if exists and then create */

USE [master]
GO

ALTER DATABASE [WebAppMonitor] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

USE [master]
GO

DROP DATABASE [WebAppMonitor]
GO

CREATE DATABASE WebAppMonitor
GO
