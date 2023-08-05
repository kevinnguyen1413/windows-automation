function checkenoughspace {
    if($DestFreeSpace*0.9 -gt $SourceUsedSpace) {
        Write-Output "Enough space. Creating new backup"
        return $true
    } else {
        Write-Output "Not enough space! Deleting oldest backup"
        return $false
    }
}