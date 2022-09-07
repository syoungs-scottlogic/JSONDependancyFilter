# Filter through JSON document and remove duplicate dependancies. 
$depArray = @()
$data = Get-content "C:\Users\syoungs\OneDrive - Scott Logic Ltd\Documents\SG-payments-dependencies.json"
$list = $data | convertfrom-json
#$list[0].name
foreach($bit in $list)
{
    #Write-Host "$($bit.name)"
    $depArray += $bit.name
}

$depArray | select -Unique

<#
foreach dep in deparray
    if dep == 
#>


$count = $($depArray | select -Unique).count
write-host "`nThere are a total of $($count) unique dependancies."
#$($depArray | select -Unique).count