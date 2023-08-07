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
    $enoughSpace = checkenoughspace
    $backupsExist = checkbackups
    if (($enoughSpace) -eq $false -And ($backupsExist -eq $true)) {
        Write-Host "Not enough space!"
        $deletedBackup = deleteoldestbackup
        if (($deletedBackup) -eq $true -And (checkenoughspace -eq $true)) {
        createandcopy
        }
        else {
            Write-Host 'There is only 1 backup but there is not enough space to create a 2nd backup. Please check destination drive.'
            exit
        }
    } elseif (($enoughSpace) -eq $true -And ($backupsExist -eq $true)) {
        Write-Host "Enough space"
        createandcopy
    } else {
        Write-Host 'The script has encountered error(s). Please check code.'
        exit
    }
}


function checkenoughspace {
    if(($DestFreeSpace*0.9) -gt $SourceUsedSpace) {
        return $true
    } elseif (($DestFreeSpace*0.9) -lt $SourceUsedSpace) {
        return $false
    } else {
        Write-Host 'True/False not working.'
    }
}

function checkbackups {
    if ($count -ge 0) {
        Write-Host 'Backup(s) at destination:' $count
        return $true
    } else {
        Write-Host 'The script has encountered error(s). Please check code.'
        exit
    }
}

function deleteoldestbackup {
    if ($count -le 1) {
        Write-Host 'There is' $count 'backup. No need to delete.'
        return $false
    }

    Write-Host 'There are' $count 'backups but not enough drive capacity.'
    Write-Host 'Keeping latest backup:'
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -First 1 | Write-Host
    Write-Host 'Deletion targets are:' 
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Write-Host
    Write-Host 'Deletion will begin in 5 seconds.'
    Start-Sleep -Seconds 10
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
    Write-Host 'Deletion completed.'
    return $true
}

function createandcopy {
    Write-Host 'Creating new backup.'
    $folderName = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")
    $newdir = Join-Path $DestDrive $folderName
    New-Item -ItemType Directory -Path $newdir
    robocopy "$SourceDrive" "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
    Write-Host 'Backup created at' $newdir
}

main