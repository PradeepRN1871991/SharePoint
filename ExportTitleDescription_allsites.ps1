<# This script will fetch Title, Url, Description from the all subsite and rootweb to a csv file #>
<# This script requires PNP Powershell commandlets to be installed on the machine from which the script is running#>
<# give appropriate credentials to connect to the site#>
<# provide the export path in the script#>


Connect-PnPOnline -Url ""
$titlecollection=@()
$rootweb=Get-PnPWeb
$rootweb.Title
$rootweb.Url
$toplevelsitetitle=New-Object -TypeName PSObject
$toplevelsitetitle | Add-Member -MemberType NoteProperty -Name "Site Url" -Value $rootweb.Url
$toplevelsitetitle | Add-Member -MemberType NoteProperty -Name "Title" -Value $rootweb.Title
$toplevelsitetitle | Add-Member -MemberType NoteProperty -Name "Description" -Value $rootweb.Description
$titlecollection+=$toplevelsitetitle
$allwebs=Get-PnPSubWebs -Recurse

foreach($web in $allwebs)
{
$subsitetitles=New-Object -TypeName PSObject
$subsitetitles|Add-Member -MemberType NoteProperty -Name "Site Url" -Value $web.Url
$subsitetitles|Add-Member -MemberType NoteProperty -Name "Title" -Value $web.Title
$subsitetitles|Add-Member -MemberType NoteProperty -Name "Description" -Value $web.Description
$titlecollection+=$subsitetitles
}

$titlecollection | Export-Csv -Path "" -NoTypeInformation