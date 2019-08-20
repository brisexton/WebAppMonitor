# WebAppMonitor

This project contains a PowerShell Module, MS SQL Server Database and Task Scheduler scripts to check for website availability and then logs the results to the database.

In addition to the logging, there is also the abililty to notify via email. There's the ability to setup notifications via SMS using Twilio and this is in the pipeline for down the road.

## Setup and Installation

1. Create the Database.


2. Create a SQL Login to connect to the Database.


3. Create a local user account on the server to run the job as.


4. Persist the SQL Login Credentials to disk on the server.


5. Add Web Sites to monitor


6. Register Job with Task Scheduler

Run Install-WAMScheduledTask to register a scheduled task with Task Scheduler.
