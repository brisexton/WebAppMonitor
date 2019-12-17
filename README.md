# WebAppMonitor

This project contains a PowerShell Module, MS SQL Server Database and Task Scheduler
scripts to check for website availability and then logs the results to the database.

In addition to the logging, there is also the abililty to notify via email. There's
the ability to setup notifications via SMS using Twilio and this is in the pipeline
for down the road.

## Setup and Installation

1. Save the PS Module and WAMRuntime.ps1 file somewhere on the file system.


2. Create the Database.


3. Create a SQL Login to connect to the Database.


4. Create a local user account on the server to run the job as.


5. Persist the SQL Login Credentials to disk on the server.


6. Add Web Sites to monitor


7. Add SMTP server configuration for email notifications.


8. Register task with Task Scheduler


A Step-by-Step example of how to install/setup/configure all settings can be found in
/Scripts/ExampleSetup-1.ps1
