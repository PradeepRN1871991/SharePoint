<# This script will set logo from specific location to all sites and subsites from a CSV File #>
<# This script requires PNP powershell commandlets to be installed #>
<# provide the path of the csv file#>
<# the csv file should have all web url(both site and subsite url) under the Header Name "URL" #>
<# provide the site logo url to be updated #>
<# Provide the username and password for the site #>
<# verify the random site urls to check if the required logo url is updated for the site/subsite#>

$LOGocontents=Import-Csv -Path ""
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$credential=New-Object system.management.automation.pscredential($username,$securepass)

foreach($logocontent in $LOGocontents)
{
Connect-PnPOnline -Url $logocontent.URL -Credentials $credential
$rootweb=Get-PnPWeb
$context=Get-PnPContext
$context.Load($context.Web)
$context.ExecuteQuery()
$context.Web.SiteLogoUrl=""
$context.Web.Update()
$context.ExecuteQuery()
Write-Host "Finally logo set" $context.Web.SiteLogoUrl "For this site" $context.Web.Url
}


