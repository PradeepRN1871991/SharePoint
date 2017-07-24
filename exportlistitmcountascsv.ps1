<# This script will get itemcount report from rootweb and all the subsites with in a site collection #>


$credentials = $null
$SPOCredentials = $null
$ListInfo=@();

function connectToO365{
 
# Let the user fill in their admin url, username and password
 
$siteUrl =  "" #Read-Host "Enter the Admin URL of 0365 (eg. https://<Tenant Name>-admin.sharepoint.com)"
 
$userCredential = Get-Credential

$SPOCredentials =  New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($userCredential.UserName,$userCredential.Password)
 
$ExportRowCollection = @();

$ExportRowCollection = Get-SPOWebs($siteUrl)
 
 $ExportRowCollection | Export-Csv -Path ""

}
 
function Get-SPOWebs($url){
$ListInfo = @();

#fill metadata information to the client context variable
 
$context = New-Object Microsoft.SharePoint.Client.ClientContext($url)
 
$context.Credentials = $SPOcredentials
 
$web = $context.Web
 
$context.Load($web)
 
$context.Load($web.Webs)
 
$context.load($web.lists)
 
try{
 
$context.ExecuteQuery()
 
#loop through all lists in the web
 
foreach($list in $web.lists){

 Write-Host $web.Url
 Write-Host $list.title + $list.itemcount 
$listinformation=New-Object PSObject
$listurl=$web.Url+"/"+$list.Title
$listinformation | Add-Member -MemberType NoteProperty -Name "Site Url" -Value $web.Url
$listinformation | Add-Member -MemberType NoteProperty -Name "List Name" -Value $list.Title
$listinformation | Add-Member -MemberType NoteProperty -Name "List Item Count" -Value $list.ItemCount
$listinformation | Add-Member -MemberType NoteProperty -Name "List url" -Value $listurl
$ListInfo+=$listinformation
}


 
 
foreach($web in $web.Webs) {
 
write-host "Info: Found $($web.url)" -foregroundcolor green
 
$ListInfo += Get-SPOWebs($web.url)
 
}

return $ListInfo;
}

 
catch{
 
write-host "Could not find web" -foregroundcolor red  $_.Exception
 
}

 
}


connectToO365

