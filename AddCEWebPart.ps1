Add-PSSnapin microsoft.sharepoint.powershell
# function to set the content editor webpart
function SetContentEditorWebPart($path)
{
# get contents from csv file
$csvcontents=Import-Csv -Path $path
foreach($site in $csvContents)
{
#iterate through each site and add content editor webpart on the home page of the site
$url=$site.'Site Url'
$website=Get-SPSite -Identity $url
$web=$website.RootWeb
$wpmgr=$web.GetLimitedWebPartManager($web.RootFolder.WelcomePage,[system.web.ui.webcontrols.webparts.personalizationscope]::Shared)
$contenteditorwebpart=New-Object microsoft.sharepoint.webpartpages.ContentEditorWebPart
$contenteditorwebpart.Title="Site Migration Information"
$contenteditorwebpart.ChromeType=[system.web.ui.webcontrols.webparts.PartChromeType]::TitleAndBorder
[system.Xml.XmlDocument]$content=New-Object system.Xml.XmlDocument
[system.Xml.XmlElement]$contentxml=$content.CreateElement("MigrationContent")
$contentxml.InnerText="Your SharePoint site has migrated to O365!"+" "+"<a href="+$site.'New Site'+">Here</a>"+" "+"is the link for the O365 site."
$contenteditorwebpart.Content=$contentxml
$wpmgr.AddWebPart($contenteditorwebpart,"Header",1)
$wpmgr.SaveChanges($contenteditorwebpart)
}

}
# Provide the path of Csv File containing site urls and call the function
SetContentEditorWebPart("Path for the Csv File")
