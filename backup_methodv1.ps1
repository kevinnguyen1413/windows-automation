

function main {
    checkenoughspace
    checkhowmanybackup
    if ((checkenoughspace) -eq $false -And (checkhowmanybackup -eq $true)) {
        deleteoldestbackup
        checkenoughspace
        if ((deleteoldestbackup) -eq $true -And (checkenoughspace -eq $true)) {
            createandcopy
        } else {
            Write-Output 'The script has encountered error(s). Please check code.'
            exit
        }
    } elseif ((checkenoughspace) -eq $true -And (checkhowmanybackup -eq $true)) {
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