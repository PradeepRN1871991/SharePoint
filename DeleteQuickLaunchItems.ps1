<# This script is used for deleting the quick launch items in the site#>

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
$arraylist=@()
$navigationcollection1=$clientcontext1.web.Navigation.QuickLaunch
$clientcontext1.Load($navigationcollection1)
$clientcontext1.ExecuteQuery()
foreach($navigationnode1 in $navigationcollection1)
{
$arraylist+=$navigationnode1
}
foreach($listdelete in $arraylist)
{
$listdelete.DeleteObject()
$clientcontext1.ExecuteQuery()
}
$clientcontext1.Web.Update()
}


$clientcontext1=connectto0365site
$navigationdetails1=Navigation
