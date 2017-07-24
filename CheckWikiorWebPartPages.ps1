

<# This script will check whether the page in a library is a wikipage or a webppart page#>
<# This script requires PNP powershell commandlets to be installed #>
<# provide the site url and credentials#>



Connect-PnPOnline -Url ""

$doclibraries=Get-PnPList | Where-Object {($_.BaseTemplate -eq 119) -or ($_.BaseTemplate -eq 850) -or ($_.BaseTemplate -eq 101) }
$doclibraries.Count

$items=Get-PnPListItem -List "Site Pages"


#Get-PnPField -List "Site Pages"

foreach($item in $items)
{
 if($item["ContentTypeId"].StringValue.Contains('0x010108'))
 {
   Write-Host "Wiki Page Found"
 }
 elseif($item["ContentTypeId"].StringValue.Contains('0x010109'))
 {
   Write-Host "Webpart page found"
 }
}

$subsites=Get-PnPSubWebs -Recurse
foreach($web in $subsites)
{
$subweb=Get-PnPWeb -Identity $web
$doclib=Get-PnPList Get-PnPList | Where-Object {($_.BaseTemplate -eq 119) -or ($_.BaseTemplate -eq 850) -or ($_.BaseTemplate -eq 101)}
$itemssub=Get-PnPListItem -List "Site Pages"

foreach($itemsub in $itemssub)
{
 if($itemsub["ContentTypeId"].StringValue.Contains('0x010108'))
 {
   Write-Host "Wiki Page Found"
 }
 elseif($itemsub["ContentTypeId"].StringValue.Contains('0x010109'))
 {
   Write-Host "Webpart page found"
 }
}
}
