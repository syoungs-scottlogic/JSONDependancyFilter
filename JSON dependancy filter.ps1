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
    $depPackageManager += $bit.packager
    $depLocation += $bit.location.path
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
    $count = $($depArray | select -Unique).count
    write-host - "`nThere are a total of $($count) unique dependancies."
}

function FilterByPacketManager()
{
        # GET a list of dependancies without a package manager.
        # try adding createing another function CheckListPM to run through the while i <= list.length and return the data. Add to starred area l:65
    $pManDeps = @()
    
    $pManList = $depPackageManager | select -Unique

    $choice = 1
    foreach($entry in $pManList)
    {
        if($entry -eq "")
        {
            Write-Host "$($choice). This is not a package manager. Possibly manually installed or part of OS" 
        }
        else {Write-Host "$($choice). $($entry)"}
        
        $choice++
    }
    [int]$pManChoice = Read-Host -Prompt "`nPlease select of the options above to see all installed dependancies for the chosen package manager."
    if($pManChoice -lt $choice -and $pManChoice -gt 0 -and $pManChoice -is [int])
    {
        # show dependancies
        $pManChoice--
        Write-Host "yerrrrr $($pManChoice)"
        foreach($entry in $list)
        {
            if($entry.packager -eq $pManList[$pManChoice])
            {
                #Write-Host
                $pManDeps += $entry.name
            }
        }
        $uniquePManDeps = $pManDeps | Sort-Object -Unique
        
        Write-Host "All installed dependancies for $($pManList[$pManChoice]):`n"
        Write-Host ($uniquePManDeps -join "`n")
        Write-Host "`nEnd all installed dependancies for $($pManList[$pManChoice])"
        
    }
    else { FilterByPacketManager }
}


function FilterByPath()
{
    #
}


### Final Output ###
#ShowDependancies
FilterByPacketManager

### Exit script ###
Read-Host -Prompt "Press enter to exit"