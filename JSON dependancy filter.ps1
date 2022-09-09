Add-Type -AssemblyName System.Windows.Forms

# AUTHOR: s.youngs

#- Filter through JSON document and remove duplicate dependancies. 
#- Show all package managers
#- Show all paths and packages related. 

## to do ##
#- Create mark down file detailing what to do

### variables ###
$depArray = @()
$depLocation = @()
$depPackageManager = @()
$data = Get-content ".\input.json"
$list = $data | convertfrom-json
foreach ($bit in $list) {
    $depArray += $bit.name
    $depPackageManager += $bit.packager
    $depLocation += $bit.location.path
}
$depNames = $depArray | select -Unique 

# Save the output to a text file. 
function OutputToFile() {
    $location = Get-Location | ft -HideTableHeaders
    $saveFile = New-Object System.Windows.Forms.SaveFileDialog -Property @{ InitialDirectory = "$($location)" }
    $saveFile.FileName = "Result"
    $saveFile.DefaultExt = ".txt"
    $saveFile.Filter = "Text Documents (.txt)|*.txt"
    if ($saveFile.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $saveFile.FileName
    }
}

# Get a procedural list of all dependancies, their versions and their package manager.
function ShowDependancies() {
    $i = 0
    while ($i -le $list.Length) {
        foreach ($dep in $depNames) {
            if ($dep -eq $list[$i].name) {
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
    write-host -NoNewline " unique dependancies.`n"

    do {
        $check = Read-Host -Prompt "Would you like to save the dependancies to a text file? y/n" 
    }
    while ($check -notin 'y', 'n')
    switch ($check) {
        'y' {
            $saveFile = OutputToFile
            $uniquePManDeps | Out-File $saveFile -Append
        }
        'n' {}
    }

    Read-Host -Prompt "Press enter to return to menu"
    BeginInformation
}

# Show all package managers and then show all dependencies installed by it.
function FilterByPacketManager() {
    $pManDeps = @()
    
    $pManList = $depPackageManager | select -Unique

    $choice = 1
    foreach ($entry in $pManList) {
        if ($entry -eq "") {
            Write-Host "$($choice). This is not a package manager. Possibly manually installed or part of OS" 
        }
        else { Write-Host "$($choice). $($entry)" }
        
        $choice++
    }
    [int]$pManChoice = Read-Host -Prompt "`nPlease select of the options above to see all installed dependancies for the chosen package manager."
    if ($pManChoice -lt $choice -and $pManChoice -gt 0 -and $pManChoice -is [int]) {
        $pManChoice--
        foreach ($entry in $list) {
            if ($entry.packager -eq $pManList[$pManChoice]) {
                $pManDeps += $entry.name
            }
        }
        $uniquePManDeps = $pManDeps | Sort-Object -Unique
        
        Write-Host -ForegroundColor Green "`nAll installed dependancies for $($pManList[$pManChoice]):`n"
        Write-Host ($uniquePManDeps -join "`n")
        Write-Host -ForegroundColor Green "`nEnd all installed dependancies for $($pManList[$pManChoice])`n"
        $count = $($uniquePManDeps).count
        write-host -NoNewline "`nThere are a total of "
        write-host -NoNewline -ForegroundColor Magenta $count
        write-host -NoNewline " unique dependancies installed via $($pManList[$pManChoice]).`n"
        do {
            $check = Read-Host -Prompt "Would you like to save the dependancies to a text file? y/n" 
        }
        while ($check -notin 'y', 'n')
        switch ($check) {
            'y' {
                $saveFile = OutputToFile
                $uniquePManDeps | Out-File $saveFile -Append
            }
            'n' {}
        }
    }
    else { FilterByPacketManager }
    Read-Host -Prompt "Press enter to return to menu"
    BeginInformation
}

# Show all containers then list all dependancies installed under the chosen one.
function FilterByPath() {
    #
    $depLocList = $depLocation | select -Unique
    $locListArr = @()

    $choice = 1
    foreach ($entry in $depLocList) {
        Write-Host "$($choice). $($entry)"
        $choice++
    }

    [int]$userChoice = Read-Host -Prompt "`nPlease select a location above to see all dependancies installed for it."
    $userChoice--

    if ($userChoice -gt 0 -and $userChoice -le $userChoice -and $userChoice -is [int]) {
        foreach ($item in $list) {
            if ($item.location.path -eq $depLocList[$userChoice]) {
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

        do {
            $check = Read-Host -Prompt "Would you like to save the dependancies to a text file? y/n" 
        }
        while ($check -notin 'y', 'n')
        switch ($check) {
            'y' {
                $saveFile = OutputToFile
                $uniquePManDeps | Out-File $saveFile -Append
            }
            'n' {}
        }
    }
    else { FilterByPath }

    Read-Host -Prompt "Press enter to return to menu"
    BeginInformation
}

function BeginInformation() {
    Clear-Host
    Write-Host "1. Show all installed dependancies, their version, and package manager."
    Write-Host "2. Show all package managers, and their specific dependancies."
    Write-Host "3. Show all paths/containers, and their specific dependancies."
    Write-Host "9. Exit menu`n"
    Do {
        [int]$response = Read-Host -Prompt "Please select an option"
    }while ($response -notin 1, 2, 3, 9)
    switch ($response) {
        1 { ShowDependancies }
        2 { FilterByPacketManager }
        3 { FilterByPath }
        9 { <# Exit #> }
    }
        
}


function Main() {
    Write-Host "###################################" -BackgroundColor Green -ForegroundColor Red
    Write-Host "#                                 #" -BackgroundColor Green -ForegroundColor Black
    Write-Host "#  List installed dependancies    #" -BackgroundColor Green -ForegroundColor Black
    Write-Host "#    collected via JSON dump      #" -BackgroundColor Green -ForegroundColor Black
    Write-Host "#                                 #" -BackgroundColor Green -ForegroundColor Black
    Write-Host "###################################`n`n" -BackgroundColor Green -ForegroundColor Black

    Write-Host "1. Load data from file."
    Write-Host "2. Load data from .\input.json"
    Write-Host "9. Exit."

    do {
        [int]$response = Read-Host -Prompt "Please select and option"
    }while ($response -notin 1, 2, 9)
    switch ($response) {
        1 {
            try {
                $location = Get-Location | ft -HideTableHeaders
                $fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory =
                    "$($location)"
                    Filter                                                                                  = "Json (*.json) |*.json"
                }
                $null = $fileBrowser.ShowDialog()
                $data = Get-Content $fileBrowser.FileName
                BeginInformation
            }
            catch {
                Write-Host "Incorrect file type. Please select a .json file."
                Read-Host -Prompt "Press enter to return to main menu."
                Main
            }

        } 
        2 { 
            if ($data) {
                BeginInformation
            }
            else {
                Write-Host "There is no input.json file in the current directory. Please ensure it's there or
                    select a file by using option 1. Press enter to return to main menu."
                Read-Host
                Main
            }
            
        }
        9 { <# exit #> }
    }
}

### Final Output ###
Main
### Exit script ###
Read-Host -Prompt "`nPress enter to exit application"