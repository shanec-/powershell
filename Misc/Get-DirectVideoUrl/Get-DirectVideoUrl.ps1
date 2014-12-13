#================================================
# Helper Script to extract the direct download url of external video services (mainly youtube.com) using the the keepvid.com service
# Author: Shane Carvalho (shanec_@hotmail.com)
# Date: 2014/10/20
#
# Usage:
#    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I"
#    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q"
#    .\Get-DirectVideoUrl.ps1 -url "http://www.youtube.com/watch?v=duKL2dAJN6I http://www.youtube.com/watch?v=R4ajQ-foj2Q" -filename "C:\inputDownloadList.txt"
#
#================================================

#filename containing batch urls
param(
    [string]$url,
    [string]$fileName
    )

#global declarations/constants
$keepVidBaseUrl = "http://keepvid.com/?url=";

function Get-ScriptDirectory
{
    Split-Path -Parent $PSCommandPath
}

function Get-DirectDownloadUrl([string]$sourceHtml)
{
    $hDoc = New-Object HtmlAgilityPack.HtmlDocument
    $hDoc.LoadHtml($sourceHtml)

    $navigator = $hDoc.CreateNavigator()
    $result = $navigator.Evaluate("//div[@id='dl']/b[contains(text(),'Max 480')]/preceding-sibling::a/@href").InnerXml
    $result
}

#===================[Imports and Stuff]===============================
$scriptDir = Get-ScriptDirectory

Add-Type -Path "$scriptDir\HtmlAgilityPack.dll"
Add-Type -AssemblyName System.Web

$vids = $url.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries);

if($fileName)
{
    $fileVids = Get-Content $fileName
    $vids = $vids + $fileVids
}

$i = 1
$totalVids = $vids.length

foreach($vid in $vids)
{
    Write-Progress -Activity "Processing $totalVids Videos" -Status $vid -percentcomplete (($i / $totalVids) * 100) -currentOperation "Invoking KeepVid webservice"

    $keepRequestUrl = $keepVidBaseUrl + [System.Web.HttpUtility]::UrlEncode($vid)
    $res= Invoke-WebRequest -Uri $keepRequestUrl

    $directUrl = Get-DirectDownloadUrl($res.RawContent)

    Add-Content -Value "`n$directUrl" -Path "$scriptDir\result.txt"

    Write-Progress -Activity "Processing Videos" -Status $vid -percentcomplete (($i / $vids.length) * 100) -currentOperation "Url successfully extracted!"

    $i++
    Start-Sleep -m 500
}
