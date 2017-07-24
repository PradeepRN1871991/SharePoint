<# This script will give the item count and  View Count in a site and prints it in a CSV FILE #>
<# provide the site url, the export path for the output#>


Connect-PnPOnline ""
$context=Get-PnPContext
$content="List"+","+"ViewCount"+","+"Item Count"
$content+="`n"
$lists=Get-PnPList

foreach($list in $lists)
{
if(($list.Hidden -eq $false))
{
Write-Host $list.Title
$context.Load($list)
$context.ExecuteQuery()
Write-Host "Item Count" $list.ItemCount
$views=Get-PnPView -List $list
Write-Host "View Count"$views.Count
$content+=$list.Title+","+$views.Count+","+$list.ItemCount
$content+="`n"
}
}
[system.io.file]::WriteAllText("path of the csv file",$content)