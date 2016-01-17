param
(
    [string]$sourceFile,
    [string]$destinationFile
)

# match all videos in the source file
$results = Select-String -Path $sourceFile  -Pattern '(?<=\")/watch?(.*?)(?=\")'

foreach($v in $results)
{
    $mergedResults += $v.Matches
}

# flatten results, remove duplicates, generate final url and write to file
$mergedResults.Value | Sort-Object | Get-Unique | % { "http://www.youtube.com" + $_ } | Add-Content $destinationFile