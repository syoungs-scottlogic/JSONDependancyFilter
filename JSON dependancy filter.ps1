# Filter through JSON document and remove duplicate dependancies. 
$depArray = @()
$i = 0
$data = Get-content "C:\Users\syoungs\OneDrive - Scott Logic Ltd\Documents\SG-payments-dependencies.json"
$list = $data | convertfrom-json
#$list[0].name
foreach($bit in $list)
{
    #Write-Host "$($bit.name)"
    $depArray += $bit.name
}

$depNames = $depArray | select -Unique


# ADDITIONAL add packager (yum or yarn?) and format into table. 
$verResult = $list[$i].version
foreach($dep in $depNames)
{
    if($dep -eq $list[$i].name)
    {
        
        Write-Host "Package name: $($dep). `n            Version: $($verResult)"
    }
    $i++;
}

$count = $($depArray | select -Unique).count
write-host "`nThere are a total of $($count) unique dependancies."
