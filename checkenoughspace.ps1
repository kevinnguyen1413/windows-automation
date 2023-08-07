function checkenoughspace {
    if(($DestFreeSpace*0.9) -gt $SourceUsedSpace) {
        Write-Output "Enough space"
        return $true
    } else {
        Write-Output "Not enough space!"
        return $false
    }
}