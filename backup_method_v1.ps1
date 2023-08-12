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

#The main function will perform the folllowing steps:
#1. If there is not enough space, deletion of oldest backup(s) will start. Else, if there is enough space, create a new backup.
#2. If deletion of oldest backup(s) was successful and there is enough space, create a new back up.
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


#Function to check if there is enough space in destination drive.
#Free space in destination drive is multiplied by 0.9 to compensate for missing capacity due to calculation of storage capacity.
function checkenoughspace {
    if(($DestFreeSpace*0.9) -gt $SourceUsedSpace) {
        return $true
    } elseif (($DestFreeSpace*0.9) -lt $SourceUsedSpace) {
        return $false
    } else {
        Write-Host 'True/False not working.'
    }
}

#Function to check for the number of backup currently in the drive. Only check for 0 or more backup(s).
function checkbackups {
    if ($count -ge 0) {
        Write-Host 'Backup(s) at destination:' $count
        return $true
    } else {
        Write-Host 'The script has encountered error(s). Please check code.'
        exit
    }
}

#Function to delete backup. First the function will check if there are 1 or fewer backup. If so -> skip deletion.
#If there is not enough capacity in the drive, the function will display the backup that will be kept and the backup(s) that will be deleted.
#You have 10 seconds before the deletion starts.
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
    Write-Host 'Deletion will begin in 10 seconds.'
    Start-Sleep -Seconds 10
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
    Write-Host 'Deletion completed.'
    return $true
}

#Function to create a new drive with yyyy-mm-dd format for name and will copy all files from source drive to destination drive.
#After the function finishes copying, location of newly created backup will be displayed.
function createandcopy {
    Write-Host 'Creating new backup.'
    $folderName = (Get-Date).ToString("yyyy-MM-dd")
    $newdir = Join-Path $DestDrive $folderName
    New-Item -ItemType Directory -Path $newdir
    robocopy "$SourceDrive" "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
    Write-Host 'Backup created at' $newdir
}

main