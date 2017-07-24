<# This script is used to update the lookup column properties as per the destination list#>
<# Provide the site url, username, password #>
<# Provide the required List Name #>

<# Change authentication for the online site#>

Clear-Host
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force

$credential=New-Object system.management.automation.pscredential($username,$securepass)


Connect-PnPOnline -Url "" -Credentials $credential

$listreq=Get-PnPList -Identity ""

$context=Get-PnPContext

$destinationlist=Get-PnPList -Identity ""

$fieldsreq=Get-PnPField -List $listreq 

foreach($fieldreq in $fieldsreq)
{
if($fieldreq.StaticName.Contains(""))
{
$fieldreq.SchemaXml
Write-Host $destinationlist.Id
$fieldreq.SchemaXml
$fieldreq.SchemaXml.Replace($fieldreq.SchemaXml.Substring(96,38),"{"+$destinationlist.Id.ToString()+"}")
$fieldreq.SchemaXml.Replace($fieldreq.SchemaXml.Substring(283,38),"{"+$listreq.Id.ToString()+"}")
$fieldreq.Update()
$listreq.Update()
$context.ExecuteQuery()
$fieldreq.SchemaXml
}
}
