#- Filter through JSON document and remove duplicate dependancies. 
#- Show all package managers
#- Show all paths and packages related. 

### variables ###
$depArray = @()
$depLocation = @()
$depPackageManager = @()
$data = Get-content "C:\Users\syoungs\OneDrive - Scott Logic Ltd\Documents\SG-payments-dependencies.json"
$list = $data | convertfrom-json
#$list[0].name
foreach($bit in $list)
{
    #Write-Host "$($bit.name)"
    $depArray += $bit.name
}
$depNames = $depArray | select -Unique 

# Get a procedural list of all dependancies, their versions and their package manager.
function ShowDependancies()
{
    $i = 0
    

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
}

function FilterByPacketManager()
{
        # GET a list of dependancies without a package manager.
        # try adding createing another function CheckListPM to run through the while i <= list.length and return the data. Add to starred area l:65
    foreach($pm in $list)
    {
        $global:depPackageManager += $pm.packager
    }
    $pManList = $depPackageManager | select -Unique
    #$pManList
    $arr_i = 0

    
    $i = 0
    $j = 0

    while($i -le $list.Length)
    {
        while($j -le $pManList.Length)
        {
            $host = $pManList[$j]
            Write-Host "$($host) has the following dependancies."
            # *******
            $j++
        }        
        foreach($pMan in $pManList)
        {
            #write-Host "Package Manager $($pMan)"
            #Write-Host "  Contains the following Dependancies:"
            $output = $list[$i].name
            
            if($pMan -eq $list[$i].packager)
            {
                #Write-Host "    $($output)"
            }
        }
        $i++
    }
}

function FilterByPath()
{
    #
}


### Final Output ###
#ShowDependancies
FilterByPacketManager
$count = $($depArray | select -Unique).count
write-host - "`nThere are a total of $($count) unique dependancies."

### Exit script ###
Read-Host -Prompt "Press enter to exit"