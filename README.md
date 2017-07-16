# Misc Red Team Powershell Scripts

## Get-DNSARecords.ps1  

Grab a list of A Records from a Microsoft DNS server and save as CSV.

### Example Use
```
Get-DNSARecords -Server 192.168.1.1 -CSVPath c:\temp\dns.csv -UserName DOMAIN\Administrator -Password Password123
```

## SQL-Shortcuts.ps1  
Some shortcuts for exfiltrating info from MSSQL servers. 
* Get database names
* Get tables from database
* Enumerate databases and tables and save to text file.

## Note
All of this stuff is under construction! 
