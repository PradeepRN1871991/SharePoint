<# This script will add web part to the given webpart page #>

<# Input parameters are
  1. Page Url on which the webparts are to configured, Username and password required for the site
  2. Path of the Webpart XML file which needs to be manipulated as per the required list
  3. HardCode the List/Library in the script in the List Array
  4. Input the Site url
  #>


  <# Prerequistes#>
  <# PNP Commandlets should be installed #>
<# Export any List Webpart from any site page #>


<# logic used 

  * The various properties in the xml file is manipulated to the required value

#>


function ConnectOnline([string]$url)
{
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$credential=New-Object system.management.automation.pscredential($username,$securepass)
Connect-PnPOnline -Url $url -Credentials $credential
}

function AddRequiredWebPart([string]$listname,[string]$homepageurl,[string]$path)
{

Write-Host $homepageurl
$list= Get-PnPList | where Title -EQ $listname | select Id,ParentWebUrl,Title,DefaultViewUrl

 Write-Host $list.Id
 Write-Host $list.ParentWebUrl
 Write-Host $list.Title
 [xml]$xmlcontent=Get-Content($path)
 Write-Host $list.DefaultViewUrl
 $xmlcontent.webParts.webPart.data.properties.property[8].InnerXml=$list.Id
 $xmlcontent.webParts.webPart.data.properties.property[15].InnerXml= "{"+$list.Id+"}"
 $xmlcontent.webParts.webPart.data.properties.property[9].InnerXml=$list.DefaultViewUrl
 Write-Host $list.ParentWebUrl
#Add-PnPWebPartToWikiPage -ServerRelativePageUrl $homepageurl -Path $path -Row 1 -Column 2
Add-PnPWebPartToWebPartPage -ServerRelativePageUrl $homepageurl -Path $path -ZoneId "Header"  -ZoneIndex 1

}
Clear-Host
$siteurl=Read-Host "Please enter url of the site"
ConnectOnline -url $siteurl
$listarray=@()
$listarray+=""
$listarray+=""
$listarray+=""
$listarray+=""


for($i=0; $i-le $listarray.Length-1;$i++){
AddRequiredWebPart ($listarray[$i]) ("pageurl") ("path of the xml config file of the webpart")
}


 
 