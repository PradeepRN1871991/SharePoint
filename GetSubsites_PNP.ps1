<#This script will fetch all the subsites with in a site collection and export the required information as CSV File #>
<# Change authentication for the online site#>
<# This script requires PNP Powershell commandlets to be installed on the machine from which the script is running#>
<# provide the export path in the script#>

Clear-Host
$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force

$credential=New-Object system.management.automation.pscredential($username,$securepass)

$sitesub=Import-Csv -Path ""
$subsiteurl=@()

foreach($sub in $sitesub)
{
Connect-PnPOnline -Url $sub.URL -Credentials $credential

$subsiteurl+=Get-PnPSubWebs -Recurse | select Url 

}

$subsiteurl| Export-Csv -Path "" -NoTypeInformation

