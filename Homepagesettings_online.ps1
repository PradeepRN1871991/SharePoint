<# This script will change any home page in site/subsite to _layouts/viewlsts.aspx page except default.aspx"#>
<#Provide username and password to connect to the sharepoint site#>
<#Provide Site Url #>
<#Provide the path of the csv file to be exported#><#[system.io.file]::WriteAllText("",$defaultpages)#>

Clear-Host
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$webpartcollection=@()
$credential=New-Object system.management.automation.pscredential($username,$securepass)
$csvcontents=Import-Csv -Path ""
$defaultpages="Web Url"+","+"Page"
$defaultpages+="`n"

foreach($csvccontent in $csvcontents)
{

Connect-PnPOnline -Url $csvccontent.URL -Credentials $credential
$Homepageurl=Get-PnPHomePage

if($Homepageurl.ToString() -like "*default.aspx*")
{
Write-Host "The Home page is default.aspx" -BackgroundColor DarkGreen
$defaultpages+=$website.Url+","+"default.aspx"
$defaultpages+="`n"
}
else
{
Set-PnPHomePage -RootFolderRelativeUrl "_layouts/15/viewlsts.aspx" 
Write-Host "Before Fix"  
Get-PnPHomePage 
Set-PnPHomePage -RootFolderRelativeUrl $Homepageurl 
Write-Host "after the fix" $Homepageurl -BackgroundColor Cyan
Get-PnPHomePage
}
$subsites=Get-PnPSubWebs -Recurse
foreach($subsite in $subsites)
{
$website=Get-PnPWeb -Identity $subsite
$subsitehomepage=Get-PnPHomePage -Web $website
if($subsitehomepage.ToString() -like "*default.aspx*")
{
Write-Host "The home page of the subsite is default.aspx" $subsitehomepage 
$defaultpages+=$website.Url+","+"Default.aspx"
$defaultpages+="`n"
}
else
{
Set-PnPHomePage -RootFolderRelativeUrl "_layouts/15/viewlsts.aspx" 
Write-Host "Before Fix"
Get-PnPHomePage 
Set-PnPHomePage -RootFolderRelativeUrl $subsitehomepage 
Write-Host "After the Fix" $subsitehomepage -BackgroundColor Cyan
}

}

}

[system.io.file]::WriteAllText("",$defaultpages)

