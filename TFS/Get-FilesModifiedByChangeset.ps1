param(
    [string]$projectUrl,
    [string]$startChangesetId,
    [string]$endChangesetId,
    [string]$startDate,
    [string]$endDate
    )

$projectUrl = "https://silfen.visualstudio.com/defaultcollection/"
#$startChangesetId = "3232312"
$endChangesetId = "6"

$cred = Get-Credential

#hack!
$username = $cred.UserName
$password = $cred.GetNetworkCredential().Password;

function Invoke-Service([string]$restOperation, [string]$restParams)
{

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

    $request = Invoke-RestMethod -Uri $requestUri -Method Get -Headers $headers

}

######### logic logic

$changesetsOperation = 'changesets'
$changesetsParams = ""

if($startChangesetId) { $changesetsParams += "&searchCriteria.fromId=$startChangesetId" }
if($endChangesetId) { $changesetsParams += "&searchCriteria.toId=$endChangesetId" }
if($startDate) { $changesetsParams += "&searchCriteria.fromDate=$startDate" }
if($endDate) { $changesetsParams += "&searchCriteria.toDate=$endDate" }

Invoke-Service $changesetsOperation $changesetsParams