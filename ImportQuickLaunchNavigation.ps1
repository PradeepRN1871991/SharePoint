<#

This script is for importing the left navigation settings from xml file to the online site
#>
<# Provide username and password for the site#>
<# Provide the site url required #>
<# Provide the xml file input path #>


[xml]$xmlcontentvalue=Get-Content -Path ""

function connectto0365site()
{
$username=""
$password=""
$securepass=ConvertTo-SecureString -String $password -AsPlainText -Force
$securecred=New-Object system.management.automation.pscredential($username,$securepass)
$context=New-Object microsoft.sharepoint.client.clientcontext("")
$context.Credentials= New-Object microsoft.sharepoint.client.sharepointonlinecredentials($username,$securepass)
return $context
}

function Navigation()
{
$navigationcollection=$clientcontext.web.Navigation.QuickLaunch
$clientcontext.Load($navigationcollection)
$clientcontext.ExecuteQuery()
for($i=($xmlcontentvalue.NavigationDetails.ChildNodes.Count); $i -ge 0; $i--)
{
$rootnavigation=New-Object microsoft.sharepoint.client.navigationnodecreationinformation
$rootnavigation.Title=$xmlcontentvalue.NavigationDetails.ChildNodes[$i].Title
$rootnavigation.Url=$xmlcontentvalue.NavigationDetails.ChildNodes[$i].Url
$navigationcollection.Add($rootnavigation)

if($xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes.Count -gt 0)
{

for($j=$navigationcollection.Count; $j -gt 0; $j--)
{
  $navigationnode=$navigationcollection[$j]

  if($navigationnode.Title -eq $rootnavigation.Title)
  {
    $parentnode=$navigationnode
  }

}
for($k=($xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes.Count-1); $k -ge 0; $k--)
{

if($xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes.Count -eq 1)
{
$childnode=$xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes[$k]
$childnodenavigation=New-Object microsoft.sharepoint.client.navigationnodecreationinformation
$childnodenavigation.Title=$childnode.Title
$childnodenavigation.Url=$childnode.Url
Write-Host $childnodenavigation.Title "Testing child node title"
$parentnode.Children.Add($childnodenavigation)
}
else
{
Write-Host $parentnode.Title -ForegroundColor Cyan
Write-Host $xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes.Count "Total Count" -ForegroundColor DarkBlue
$childnode=$xmlcontentvalue.NavigationDetails.ChildNodes[$i].ChildNodes[$k]
$childnodenavigation=New-Object microsoft.sharepoint.client.navigationnodecreationinformation
$childnodenavigation.Title=$childnode.Title
$childnodenavigation.Url=$childnode.Url
Write-Host $childnodenavigation.Title "Testing child node title"
$parentnode.Children.Add($childnodenavigation)
}

}

$parentnode.Update()
$clientcontext.ExecuteQuery()
}
$clientcontext.ExecuteQuery()
}
$clientcontext.Web.Update()
}

$clientcontext=connectto0365site
$updatenavigation=Navigation
