<#
    .SYNOPSIS 
		Generates a delta sql script against an baseline environment.
	.EXAMPLE
        .\SqlDeltaGen.ps1 -SourceDacpac ContosoDatabase.dacpac -TargetDacpac ContosoDatabase_baseline.dacpac -OutPutDeltaFile ContosoDelta.sql -DBName contosodb

		Generates a delta script using the against the production baseline dacpac
#>

param (
    [string]$SourceDacpac,
    [string]$TargetDacpac,
    [string]$OutputDeltaFile,
    [string]$DBName
)


Write-Verbose "Attempting to generate delta script $SourceDacpac against $TargetDacpac..."

&"C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\sqlpackage" /a:Script /sf:$SourceDacpac  /tf:$TargetDacpac /op:$OutputDeltaFile /tdn:$DBName /p:IncludeTransactionalScripts=True /p:IncludeCompositeObjects=True /p:ScriptDatabaseOptions=False /p:BlockOnPossibleDataLoss=True /v:TenantSchemaName=dbo

Write-Verbose "Attempting post-processing and parameterization on generated delta script..."
$filecontent = Get-Content($OutputDeltaFile)
attrib $OutputDeltaFile -r
($filecontent -replace '\[dbo\]', '[$(TenantSchemaName)]') -replace 'USE[\s]\[\$\(DatabaseName\)\]\;', '' | Out-File $OutputDeltaFile

Write-Verbose "Delta schema file successfully generated."