##############################################################################
#.SYNOPSIS
# Sets the location n number of levels up.
#
#.DESCRIPTION
# You no longer have to cd ..\..\..\..\ to move back four levels. You can now
# just type bu 4
#
#.PARAMETER Levels
# Number of levels to move back.
#
#.EXAMPLE
# PS C:\Users\dlbm3\source\pullrequests\somePR\vsteam> bu 4
# PS C:\Users\dlbm3>
##############################################################################
function Backup-Location {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [int] $Levels
   )

   $sb = New-Object System.Text.StringBuilder

   for($i = 1; $i -le $Levels; $i++) {
      $sb.Append("../") | Out-Null
   }

   Set-Location -Path $($sb.ToString())
 }

Set-Alias bu Backup-Location

function set-as {
    [CmdletBinding()]
    param(
       [Parameter(Mandatory = $true)]
       $Name
    )
 
    New-PSDrive -PSProvider FileSystem -Name $Name -Root . -Scope Global | Out-Null
    Set-Location -LiteralPath "$($name):"
  }