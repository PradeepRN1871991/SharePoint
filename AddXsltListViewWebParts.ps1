Add-PSSnapin microsoft.sharepoint.powershell
Clear-Host

function GetList()
{
Param([Parameter(Mandatory=$true)]
[string]$path)

try
{
$csvcontents=Import-Csv -Path $path

foreach($content in $csvcontents)
{
$siteurl=Get-SPWeb -Identity $content.'Site Url'
$welcomepageurl=$siteurl.RootFolder.WelcomePage
$list1=$siteurl.Lists.TryGetList('Announcements')
AddWebPart($list1)
$list2=$siteurl.Lists.TryGetList('Documents')
AddWebPart($list2)
$list3=$siteurl.Lists.TryGetList('Shared Documents')
AddWebPart($list3)
}

}
catch
{
$exception=$_.Exception.Message
$exception | Out-File "your log path"
}
}

function AddWebPart()
{
Param([microsoft.sharepoint.splist]$list1)
try
{
$wpmgr=$siteurl.GetLimitedWebPartManager($welcomepageurl,[System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)
$listviewwebpart=New-Object Microsoft.SharePoint.WebPartPages.XsltListViewWebPart
$listviewwebpart.Title=$list1.Title
$listviewwebpart.ChromeType=[System.Web.UI.WebControls.WebParts.PartChromeType]::TitleAndBorder
$listviewwebpart.ListName=$list1.ID.ToString("B")
$listviewwebpart.ViewGuid=$list1.DefaultView.ID.ToString("B")
$listviewwebpart.ExportMode="All"
$wpmgr.AddWebPart($listviewwebpart,"Header",1)
}
catch
{
$exception=$_.Exception.Message
$exception | Out-File "your log path"
}
}

GetList