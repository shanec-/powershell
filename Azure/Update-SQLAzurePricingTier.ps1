<#
    .SYNOPSIS 
		Updates the Azure SQL Database pricing tier.
	.EXAMPLE
		.\Update-SQLAzurePricingTier.ps1 -servername "myservername.database.windows.net" -databaseName "mydatabase" -username "myuser" -password "mypwd" -serviceObjectiveName "S0" -edition "Standard" -SleepDuration 10
		Updates the Azure SQL Database pricing tier to Standard (S0)
#>

param(
    [Parameter(Position=0,mandatory=$true)]
    [string]$serverName,
    [Parameter(Position=1,mandatory=$true)]
    [string]$databaseName,
    [Parameter(Position=2,mandatory=$true)]
    [string]$username,
    [Parameter(Position=3,mandatory=$true)]
    [string]$password,
    [Parameter(Position=4,mandatory=$true)]
    [string]$serviceObjectiveName,
    [Parameter(Position=5,mandatory=$true)]
    [ValidateSet('Web', 'Business', 'Basic', 'Standard', 'Premium')]
    [string]$edition,
    [int] $sleepDuration = 0
    )

Write-Host "Initializing Azure SDK Module..." -ForegroundColor White

# Ensure that the Azure SDK is imported
Import-Module "C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Azure.psd1"

Write-Host "Processing credentials..." -ForegroundColor White

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $securepassword)

# $credential = Get-Credential

Write-Host "Initializing server context..." -ForegroundColor White

$serverContext = New-AzureSqlDatabaseServerContext -FullyQualifiedServerName $serverName -Credential $credential

$db = Get-AzureSqlDatabase $serverContext -DatabaseName $databaseName 
$so= Get-AzureSqlDatabaseServiceObjective $serverContext -ServiceObjectiveName $serviceObjectiveName

Write-Host "Attempting to set the $databaseName datbase to $serviceObjectiveName ($edition)..." -ForegroundColor White

Set-AzureSqlDatabase $serverContext -Database $db -ServiceObjective $so -Edition $edition -Force

if ($sleepDuration -gt 0)
{
    Write-Host "Starting to sleep for $sleepDuration seconds..." -ForegroundColor White
    Start-Sleep -Seconds $sleepDuration
    Write-Host "Waking up!" -ForegroundColor White
}

