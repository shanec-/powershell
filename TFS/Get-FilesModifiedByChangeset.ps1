#================================================
# Script to get a list of files changed since between two changesets or dates
# Works only with Visual Studio Online
# Author: Shane Carvalho (shanec_@hotmail.com)
# Date: 2014/12/14
#
# Usage:
#    .\Get-FilesModifiedByChangeset.ps1 -projectCollectionUrl "https://myaccount.visualstudio.com/defaultcollection/" -itemPath "$/sandbox" -startChangesetId "5"  -endChangesetId "6"
#
#================================================

param(
    [string]$projectCollectionUrl,
    [string]$itemPath,
    [string]$startChangesetId,
    [string]$endChangesetId,
    [string]$startDate,
    [string]$endDate
    )

#$projectCollectionUrl = "https://<account>.visualstudio.com/defaultcollection/"
#$itemPath = "$/sandbox"
#$startChangesetId = "5"
#$endChangesetId = "6"

$cred = Get-Credential

#hack!
$username = $cred.UserName
$password = $cred.GetNetworkCredential().Password;

function Invoke-Service([string]$restOperation, [string]$restParams)
{

    #basic authentication work around
	#http://stuartpreston.net/2014/05/accessing-visual-studio-online-rest-api-using-powershell-4-0-invoke-restmethod-and-alternate-credentials/

    #get the credentials
    $basicAuth = ("{0}:{1}" -f $username,$password)
    $basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
    $basicAuth = [System.Convert]::ToBase64String($basicAuth)
    $headers = @{Authorization=("Basic {0}" -f $basicAuth)}


    #initialize the api request url
    $baseUrl = $projectUrl.TrimEnd('/') + '/_apis/tfvc/'
    $restParams = $restParams.TrimStart('&')
    
    $requestUri = $baseUrl + $restOperation + "?api-version=1.0&" + $restParams

    $result = Invoke-RestMethod -Uri $requestUri -Method Get -Headers $headers

	return $result
}

### Generate the parameters and filters necessary
$changesetsParams = ""

if($itemPath) { $changesetsParams += "&searchCriteria.itemPath=$itemPath" }
if($startChangesetId) { $changesetsParams += "&searchCriteria.fromId=$startChangesetId" }
if($endChangesetId) { $changesetsParams += "&searchCriteria.toId=$endChangesetId" }
if($startDate) { $changesetsParams += "&searchCriteria.fromDate=$startDate" }
if($endDate) { $changesetsParams += "&searchCriteria.toDate=$endDate" }

$changesetResults = Invoke-Service 'changesets' $changesetsParams

#iterate through all the changesets to figure out the project we need
foreach ($cid in $changesetResults.value.changesetId)
{
    $changesetDetail = Invoke-Service "changesets/$cid/changes" ""
    $changes = $changesetDetail.value | ConvertTo-Json | ConvertFrom-Json

    foreach($ch in $changes)
    {
        #ignore the folders
        if($ch.item.isFolder -ne $true)
        {
            if($ch.item.path)
            {
                Write-Host $ch.item.path
            }
        }
    }
}