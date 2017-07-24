<# This script is for exporting the left navigation settings from the sharepoint site#>
<# use microsoft.sharepoint.client.sharepointonlinecredentials method for the online site authentication#>
<# Provide username, password for the site, provide siteurl from which the left navigation settings should be exported#>
<# provide the path for the xml file to be saved in the script#> <# $xmldoc.Save#>


function connectto0365site()
{
$username=""
$password=""
$securepass=ConvertTo-SecureString -String $password -AsPlainText -Force
$securecred=New-Object system.management.automation.pscredential($username,$securepass)
$context=New-Object microsoft.sharepoint.client.clientcontext("")
$context.Credentials= New-Object System.Net.NetworkCredential($username,$securepass)
return $context
}

function Navigation()
{
$navigationcollection=$clientcontext.web.Navigation.QuickLaunch
$clientcontext.Load($navigationcollection)
$clientcontext.ExecuteQuery()
[system.xml.xmldocument]$xmldoc=New-Object system.xml.xmldocument
[system.xml.xmlelement]$xmlelement=$xmldoc.CreateElement("NavigationDetails")
$xmldoc.AppendChild($xmlelement)

foreach($navigationnode in $navigationcollection)
{
 $clientcontext.Load($navigationnode.Children)
 $clientcontext.ExecuteQuery()
 $mainelement=$xmldoc.CreateElement("MainNavigation")
 $mainelement.SetAttribute("Title",$navigationnode.Title)
 $mainelement.SetAttribute("Url",$navigationnode.Url)
 $xmlelement.AppendChild($mainelement)
 if($navigationnode.Children.Count -ge 0)
 {
 foreach($childnode in $navigationnode.Children)
 {
 Write-Host $childnode.Title -ForegroundColor Magenta
 $childelement=$xmldoc.CreateElement("ChildNode")
 $childelement.SetAttribute("Title",$childnode.Title)
 $childelement.SetAttribute("Url",$childnode.Url)
 $mainelement.AppendChild($childelement)
}

 #Write-Host "This Node has Child Nodes" -ForegroundColor DarkGreen
 #GetChildnodes([System.Xml.XmlElement]$mainelement)
 }
 else
 {
 Write-Host $navigationnode.Title  -ForegroundColor Blue
 Write-Host $navigationnode.Url -ForegroundColor Cyan
 Write-Host  "Not there"-ForegroundColor Magenta $navigationnode.Children.Count
 }
}
$xmldoc.Save("")
}

function GetChildnodes([System.Xml.XmlElement]$xmlcontent)
{
Write-Host "Coming inside childnoeds"
if($xmlcontent -eq $null)
{
Write-Host "content is equal to null"
}
else
{
Write-Host "Content is there" $xmlcontent.Attributes["Title"].Value
}
}
$clientcontext=connectto0365site
$navigationdetails=Navigation
  




 
