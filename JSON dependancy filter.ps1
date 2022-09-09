#- Filter through JSON document and remove duplicate dependancies. 
#- Show all package managers
#- Show all paths and packages related. 

    ## to do ##
#- add main screen to chose between functions.
#- Add Open File Dialogue box instead of hardcoding filw. 
    # - perhaps on main screen "press 1 to open file." and a second choice to load from .\input.json
    #- try block for each
#- at end of functions go back to main screen rather than exit.
#- add colour
#- When finished, put into VSCode prettier to format code properly.

    ### variables ###
$depArray = @()
$depLocation = @()
$depPackageManager = @()
$data = Get-content "C:\Users\syoungs\OneDrive - Scott Logic Ltd\Documents\SG-payments-dependencies.json"
$list = $data | convertfrom-json
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
    write-host -NoNewline "`nThere are a total of "
    write-host -NoNewline -ForegroundColor Magenta $count
    write-host -NoNewline " unique dependancies."

}

# Show all package managers and then show all dependencies installed by it.
function FilterByPacketManager()
{
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
        $pManChoice--
        foreach($entry in $list)
        {
            if($entry.packager -eq $pManList[$pManChoice])
            {
                $pManDeps += $entry.name
            }
        }
        $uniquePManDeps = $pManDeps | Sort-Object -Unique
        
        Write-Host -ForegroundColor Green "`nAll installed dependancies for $($pManList[$pManChoice]):`n"
        Write-Host ($uniquePManDeps -join "`n")
        Write-Host -ForegroundColor Green "`nEnd all installed dependancies for $($pManList[$pManChoice])`n"
        $count = $($pManDeps).count
        write-host -NoNewline "`nThere are a total of "
        write-host -NoNewline -ForegroundColor Magenta $count
        write-host -NoNewline " unique dependancies installed via $($pManList[$pManChoice]).`n"
        
    }
    else { FilterByPacketManager }
}

# Show all containers then list all dependancies installed under the chosen one.
function FilterByPath()
{
    #
    $depLocList = $depLocation | select -Unique
    $locListArr = @()

    $choice = 1
    foreach($entry in $depLocList)
    {
        Write-Host "$($choice). $($entry)"
        $choice++
    }

    [int]$userChoice = Read-Host -Prompt "`nPlease select a location above to see all dependancies installed for it."
    $userChoice--

    if($userChoice -gt 0 -and $userChoice -le $userChoice -and $userChoice -is [int])
    {
        foreach($item in $list)
        {
            if($item.location.path -eq $depLocList[$userChoice])
            {
                $locListArr += $item.name
            }
        }

        Write-Host -ForegroundColor Green "`nAll installed dependancies for $($depLocList[$userChoice])`n"
        Write-Host ($locListArr -join "`n")
        Write-Host -ForegroundColor Green "`nEnd all installed dependancies for $($depLocList[$userChoice])`n"
        $count = $($locListArr).count
        write-host -NoNewline "`nThere are a total of "
        write-host -NoNewline -ForegroundColor Magenta $count
        write-host -NoNewline " unique dependancies installed on $($depLocList[$userChoice]).`n"
    }
    else{FilterByPath}
}


function Main()
{
    #
}

    ### Final Output ###
#ShowDependancies
#FilterByPacketManager
#FilterByPath

    ### Exit script ###
Read-Host -Prompt "`nPress enter to exit"