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

while($i -le $list.Length)
{
        #Write-Host "$($dep)"
    foreach($dep in $depNames)
    {
        if($dep -eq $list[$i].name)
        {
            $verResult = $list[$i].version
            $packager = $list[$i].packager
            Write-Host "$($dep)"
            Write-Host ". `n            Version: $($verResult)"
            Write-Host ".           Package Manager: $($packager)`n"
        }
    }
    $i++
} 

<#foreach($name in $depNames)
{
    #write-host "$name"
}#>


$count = $($depArray | select -Unique).count
write-host - "`nThere are a total of $($count) unique dependancies."

Read-Host -Prompt "Press enter to exit"