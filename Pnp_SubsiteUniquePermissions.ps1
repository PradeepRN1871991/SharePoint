<# This script is going to fetch the subsites with in a site collection which is having Unique Permission #>
<# provide username, password for the site#>
<# provide the required site url #>
<# provide the export path for the csv file #>


Function Invoke-LoadMethod()
 {
param(
   [Microsoft.SharePoint.Client.ClientObject]$Object = $(throw "Please provide a Client Object"),
   [string]$PropertyName
) 
   $ctx = $Object.Context
   $load = [Microsoft.SharePoint.Client.ClientContext].GetMethod("Load") 
   $type = $Object.GetType()
   $clientLoad = $load.MakeGenericMethod($type) 


   $Parameter = [System.Linq.Expressions.Expression]::Parameter(($type), $type.Name)
   $Expression = [System.Linq.Expressions.Expression]::Lambda(
            [System.Linq.Expressions.Expression]::Convert(
                [System.Linq.Expressions.Expression]::PropertyOrField($Parameter,$PropertyName),
                [System.Object]
            ),
            $($Parameter)
   )
   $ExpressionArray = [System.Array]::CreateInstance($Expression.GetType(), 1)
   $ExpressionArray.SetValue($Expression, 0)
   $clientLoad.Invoke($ctx,@($Object,$ExpressionArray))
}


$username=""
$password=""
$securepass=ConvertTo-SecureString $password -AsPlainText -Force
$credential=New-Object system.management.automation.pscredential($username,$securepass)
Connect-PnPOnline -Url "" -Credentials $credential
$sourcecontext=Get-PnPContext
$sites=Get-PnPSubWebs -Recurse
$values="WebUrl"+","+"Has Unique Permissions"
$values+="`n"

foreach($site in $sites)
{
$web1=Get-PnPWeb -Identity $site
$sourcecontext.Load($web1)
$sourcecontext.Load($web1.RootFolder)
#$sourcecontext.Load($web1.HasUniqueRoleAssignments)
$sourcecontext.ExecuteQuery()
Write-Host $web1.RootFolder.ServerRelativeUrl
Invoke-LoadMethod -Object $web1 -PropertyName "HasUniqueRoleAssignments"
#Invoke-LoadMethod -Object $web1 -PropertyName "HasUniqueRoleAssignments"
$sourcecontext.ExecuteQuery()
Write-Host $web1.Url
Write-Host $web1.RootFolder.WelcomePage
Write-Host $web1.HasUniqueRoleAssignments
if($web1.HasUniqueRoleAssignments)
{
 $values+=$web1.Url+","+"Yes"
 $values+="`n"
}

}
Write-Host $values


[system.io.file]::WriteAllText("",$values)

