
# Ensure that the Azure SDK is imported
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"

$user = "username"
$pass = "password"
$serverName = "myservername.database.windows.net"
$databaseName = "mydatabasename"

$securePassword = ConvertTo-SecureString $pass -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($user, $securepassword)
$credential = Get-Credential

$serverContext = New-AzureSqlDatabaseServerContext -FullyQualifiedServerName $serverName -Credential $credential

$db = Get-AzureSqlDatabase $serverContext –DatabaseName $databaseName 

$S1= Get-AzureSqlDatabaseServiceObjective $serverContext -ServiceObjectiveName "S1"

Set-AzureSqlDatabase $serverContext –Database $db –ServiceObjective $S1 –Edition Standard
