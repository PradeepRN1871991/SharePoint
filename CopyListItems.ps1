<# This script is used to copy list and list items from one site to another using CSOM#>
<# This script will copy all the field types except lookup, hyperlink, person field#>

<#Provide username and password to connect to the sharepoint site#>
<#Provide Site Url, List Name which needs to copied to the destination site#>
<#Provide destination Site Url#>

$username=""
$password=""
$securepwd=ConvertTo-SecureString $password -AsPlainText -Force
$sourceclientcontext=$null
$destinationclientcontext=$null
#>


<# connect to source site #>

function connecttosourcesite()
{
$sourceclientcontext=New-Object microsoft.sharepoint.client.clientcontext("")
$sourceclientcontext.Credentials=New-Object system.net.networkcredential($username,$securepwd)
return $sourceclientcontext
}

<# get the required List from source#>

function getlistinstance()
{
$sourcelist=$sourceclientcontext.Web.Lists.GetByTitle('')
$sourceclientcontext.Load($sourcelist)
$sourceclientcontext.ExecuteQuery()
return $sourcelist
}

<# Create List in destination site #>

function createlist()
{
$destinationlist=New-Object microsoft.sharepoint.client.listcreationinformation
$destinationlist.Title=$sourcelist.Title
$destinationlist.TemplateType =$sourcelist.BaseTemplate
$destinationlist.Description=$sourcelist.Description
$destinationclientcontext.Web.Lists.Add($destinationlist)
$destinationclientcontext.ExecuteQuery()
Write-Host "List Created succesfully" $destinationlist.Title "on the web" $destinationclientcontext.Web.Url
return $true
}

<# Create Fields in destination site #>

function createfields()
{
$destfieldcount=$destinationlist.Fields.Count

foreach($sourcefield in $sourcefields)
{
$count=1
 foreach($destinationfield in $destinationlist.Fields)
 {
   if(($destinationfield.Title -eq $sourcefield.Title) -or ($destinationfield.InternalName -eq $sourcefield.InternalName))
   {
    Write-Host "The Destination Field already Exists breaking out of the loop" 
    $count=0
    break
   }
   
 }
 if($count-eq 1)
 {
   $newfieldschema=$sourcefield.SchemaXml
   $destinationlist.Fields.AddFieldAsXml($newfieldschema,$true,[microsoft.sharepoint.client.addfieldoptions]::AddToDefaultContentType)
   $destinationclientcontext.ExecuteQuery()
   Write-Host "Field was added to the destination list the name of the field is" $sourcefield.Title -BackgroundColor Green 
 }
 else
 {
 Write-Host "Field already Exists" 
 }
}
}
<#function to copy list items #>

function createlistitems()
{
foreach($sourcelistitem in $sourcelistitems)
{
$creationinfo=New-Object microsoft.sharepoint.client.listitemcreationinformation
 $newlistitem=$destinationlist.AddItem($creationinfo)
foreach($sourcefield in $sourcefields)
{
if(($sourcefield.ReadOnlyField -eq $false) -and ($sourcefield.Hidden -eq $false) -and ($sourcefield.StaticName -ne "ContentType") -and ($sourcefield.StaticName -ne "Attachments"))
{
 $newlistitem[$sourcefield.InternalName]=$sourcelistitem[$sourcefield.InternalName]
 $newlistitem.Update()
 $destinationclientcontext.Load($newlistitem)
 $destinationclientcontext.ExecuteQuery()
 }
 
 else
 {
 Write-Host "The field name is" $destinationfield.Title
 Write-Host "The field is empty so data can be created in the item" -BackgroundColor Gray
 }



}

}

}



<# connect to destination site #>

function connecttodestinationsite()
{
$destinationclientcontext=New-Object microsoft.sharepoint.client.clientcontext("")
$destinationclientcontext.Credentials=New-Object microsoft.sharepoint.client.sharepointonlinecredentials($username,$securepwd)
return $destinationclientcontext
}


<# get source client context #>

$sourceclientcontext=connecttosourcesite
#>
$sourceclientcontext.Load($sourceclientcontext.Web)
$sourceclientcontext.ExecuteQuery()
Write-Host "Reading the web Title from Source" $sourceclientcontext.Web.Title -BackgroundColor DarkCyan

$sourcelist=getlistinstance
$sourcefields=$sourcelist.Fields
$sourcelistitems=$sourcelist.GetItems([microsoft.sharepoint.client.camlquery]::CreateAllItemsQuery())
$sourceclientcontext.Load($sourcefields)
$sourceclientcontext.Load($sourcelistitems)
$sourceclientcontext.ExecuteQuery()
Write-Host "Reading the List title from the source" $sourcelist.Title -BackgroundColor DarkMagenta
Write-Host "Fields count" $sourcefields.Count -BackgroundColor Yellow
Write-Host "Items Count" $sourcelist.ItemCount -BackgroundColor Magenta
$destinationclientcontext=connecttodestinationsite
$destinationclientcontext.Load($destinationclientcontext.Web)
$destinationclientcontext.ExecuteQuery()
Write-Host "Reading the Destination web" $destinationclientcontext.Web.Title -BackgroundColor DarkCyan
$finaldestinationlist=createlist
if($finaldestinationlist -eq $true)
{
 $destinationlist=$destinationclientcontext.Web.Lists.GetByTitle($sourcelist.Title)
 $destinationclientcontext.Load($destinationlist)
 $destinationclientcontext.ExecuteQuery()
 $destinationclientcontext.Load($destinationlist.Fields)
 $destinationclientcontext.ExecuteQuery()
}

else
{
Write-Host "Could not create a list in destination"
}

$destinationfields=createfields
createlistitems
Write-Host "The data is copied from source to destination, the count is" $destinationlist.ItemCount 





