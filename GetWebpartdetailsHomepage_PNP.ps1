<# This script is used for the getting webpart information from the home pages of all subsite and root site with in a site collection#>

<# To execute this script PNP Powershell Commandlets has to be installed #>
<# provide the username and password for authentication#>
<# provide the export path in the script#>
<# change the authentication method to microsoft.sharepoint.client.sharepointonlinecredentials for extracting information from the office365 site#>


Clear-Host
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$webpartcollection=@()

$credential=New-Object system.management.automation.pscredential($username,$securepass)

$siteurl=""
Connect-PnPOnline -Url $siteurl -Credentials $credential
$rootweb=Get-PnPWeb
$rootsitehomepage=Get-PnPHomePage 
$rootsitehomepageurl=$rootweb.ServerRelativeUrl+"/"+$rootsitehomepage

Write-Host $rootsitehomepageurl
$rootsitewebparts=Get-PnPWebPart -ServerRelativePageUrl $rootsitehomepageurl

foreach($rootwebpart in $rootsitewebparts)
{
 $rootwebparttitle=$rootwebpart.WebPart.Title
 $rootwebparttitleurl=$rootwebpart.WebPart.TitleUrl
 $rootwebpartzoneid=$rootwebpart.ZoneId
 $rootwebparttype=$rootwebpart.WebPart.GetType()
 $object1=New-Object PSObject
 $object1 | Add-Member -MemberType NoteProperty -Name "WebUrl" -Value $siteurl
 $object1 | Add-Member -MemberType NoteProperty -Name "Home Page Url" -Value $rootsitehomepageurl
 $object1 | Add-Member -MemberType NoteProperty -Name "Webparttitle" -Value $rootwebparttitle
 $object1 | Add-Member -MemberType NoteProperty -Name "Webparttitleurl" -Value $rootwebparttitleurl
 $object1 | Add-Member -MemberType NoteProperty -Name "Webpartzoneid" -Value $rootwebpartzoneid
 $object1 | Add-Member -MemberType NoteProperty -Name "Webparttype" -Value $rootwebparttype
 $object1 | Add-Member -MemberType NoteProperty -Name "WebpartCount" -Value $rootwebparts.Count
 $webpartcollection+=$object1
}



$Subsites=Get-PnPSubWebs -Recurse

foreach($subsite in $Subsites)
{
$web=Get-PnPWeb -Identity $subsite
$homepage=Get-PnPHomePage -Web $web
$homepageurl=$web.ServerRelativeUrl+"/"+$homepage
$webparts=Get-PnPWebPart -ServerRelativePageUrl $homepageurl
 foreach($webpart in $webparts)
 {
 $webparttitle=$webpart.WebPart.Title
 $webparttitleurl=$webpart.WebPart.TitleUrl
 $webpartzoneid=$webpart.ZoneId
 $webparttype=$webpart.WebPart.GetType()
 $object=New-Object PSObject
 $object | Add-Member -MemberType NoteProperty -Name "WebUrl" -Value $web.Url
 $object | Add-Member -MemberType NoteProperty -Name "Home Page Url" -Value $homepage
 $object | Add-Member -MemberType NoteProperty -Name "Webparttitle" -Value $webparttitle
 $object | Add-Member -MemberType NoteProperty -Name "Webparttitleurl" -Value $webparttitleurl
 $object | Add-Member -MemberType NoteProperty -Name "Webpartzoneid" -Value $webpartzoneid
 $object | Add-Member -MemberType NoteProperty -Name "Webparttype" -Value $webparttype
 $object | Add-Member -MemberType NoteProperty -Name "WebpartCount" -Value $webparts.Count
 $webpartcollection+=$object
 }
}

$webpartcollection | Export-Csv -Path ""