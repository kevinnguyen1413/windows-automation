$SourceDriveLetter = Read-Host -Prompt 'Input your source drive without colon and backslash'
$DestDriveLetter = Read-Host -Prompt 'Input your destination drive without colon and backslash'
$SourceDrive = $SourceDriveLetter + ':\'
$DestDrive = $DestDriveLetter + ':\'
$SourceCap = $(Get-WmiObject -Class win32_logicaldisk | Where-Object -Property Name -eq ${SourceDriveLetter}:).Size
$SourceFreeSpace = $(Get-WmiObject -Class win32_logicaldisk | Where-Object -Property Name -eq ${SourceDriveLetter}:).FreeSpace
$SourceUsedSpace = $SourceCap - $SourceFreeSpace
$DestFreeSpace = $(Get-WmiObject -Class win32_logicaldisk | Where-Object -Property Name -eq ${DestDriveLetter}:).FreeSpace
$count = (Get-ChildItem -Path $DestDrive -Directory | Measure-Object).Count
$allFolders = Get-ChildItem -Path $DestDrive -Directory
Write-Host 'Capacity at Source Drive:'$SourceCap
Write-Host 'Free Space at Source Drive:'$SourceFreeSpace
Write-Host 'Used Space at Source Drive:'$SourceUsedSpace
Write-Host 'Free Space at Destination Drive:'$DestFreeSpace

function main {
    checkenoughspace
    checkbackups
    if ((checkenoughspace) -eq $false -And (checkbackups -eq $true)) {
        deleteoldestbackup
        checkenoughspace
        if ((deleteoldestbackup) -eq $true -And (checkenoughspace -eq $true)) {
            createandcopy
        } else {
            Write-Output 'The script has encountered error(s). Please check code.'
            exit
        }
    } elseif ((checkenoughspace) -eq $true -And (checkbackups -eq $true)) {
        createandcopy
    } else {
        Write-Output 'The script has encountered error(s). Please check code.'
        exit
    }
}

function checkenoughspace {
    if($DestFreeSpace*0.9 -gt $SourceUsedSpace) {
        Write-Output "Enough space"
        return $true
    } else {
        Write-Output "Not enough space!"
        return $false
    }
}

function checkbackups {
    if ($count -le 1) {
        Write-Host $count 'backup found.'
        return $true
    } elseif ($count -ge 2) {
        Write-Host 'There are' $count 'backups.'
        return $true
    } else {
        Write-Output 'The script has encountered error(s). Please check code.'
        exit
    }
}

function deleteoldestbackup {
    Write-Output 'There are' $count 'backups but not enough drive capacity. Deletion will begin in 5 seconds. Press Ctrl+C if you want to stop now.'
    Start-Sleep -Seconds 5
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
    Write-Output 'Deletion completed.'
    return $true
}

function createandcopy {
    Write-Output 'Creating new backup.'
    $folderName = (Get-Date).tostring("yyyy-MM-dd-hh-mm-ss")
    New-Item -ItemType Directory -Path $DestDrive -Name $folderName
    $newdir = $DestDrive + $folderName
    robocopy $SourceDrive "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
    Write-Output 'Backup created at'$newdir
}

main