<#This script will give the all the views and view type for a list #>
<# provide username and password for the site#>
<# Provide the site url #>
<# provide the list name required #>
<# provide the path for the export csv file #>


Clear-Host
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$content="List Name"+","+"View Name"+","+"View Type"
$content+="`n"
$contextreq=Get-PnPContext

$credential=New-Object system.management.automation.pscredential($username,$securepass)


Connect-PnPOnline -Url "" -Credentials $credential

$testlistreq=Get-PnPList -Identity ""

$viewreq=Get-PnPView -List $testlistreq 

foreach($testview in $viewreq)
{
 write-Host $testview.ViewType
 $content+=$testlistreq.Title+","+$testview.Title+","+$testview.ViewType
 $content+="`n"
}
[system.io.file]::WriteAllText("path of the csv file",$content)




