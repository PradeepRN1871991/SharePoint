<#
To run this script .\SCAAccess.ps1 "your path of csv file"
example .\SCAAccess.ps1 "path of the csv file"

#>

<# set SCAAccess for the user present in a csv file#>
<# Provide the csv file path, csv file should contain the user email id under the Header "User Id" and also the site urls under the header name "Site Url"#>
<# provide the path for the client dlls to be used #>


function SetSCAAccess
{
Param(
[Parameter(mandatory=$true)][string]$Path
)
Add-Type -Path ""#path for microsoft.sharepoint.client dll
Add-Type -Path ""#path for microsoft.sharepoint.client.runtime dll

Clear-Host
$csvcontents=Import-Csv -Path $path
foreach($content in $csvcontents)
{
$username=$content.UserName
$password=$content.Password
$securepwd=$password | ConvertTo-SecureString -AsPlainText -Force
$ctx=New-Object microsoft.sharepoint.client.clientContext($content.'Site Url')
$credentials=New-Object microsoft.sharepoint.client.sharepointonlinecredentials($username,$securepwd)
$ctx.Credentials=$credentials
$ctx.Load($ctx.Web)
$ctx.ExecuteQuery()
$userreq=$ctx.Web.EnsureUser($content.'User Id')
$ctx.Load($userreq)
$ctx.ExecuteQuery()
if($userreq.IsSiteAdmin)
{
 Write-Host "the user is already having SCA Access for the site"
}
else
{
$userreq.IsSiteAdmin=$true
 $userreq.Update()
 $ctx.ExecuteQuery()
 Write-Host "The SCA Access has been given to the user" $userreq.IsSiteAdmin
}
}

}

SetSCAAccess