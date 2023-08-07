function checkenoughspace {
    if(($DestFreeSpace*0.9) -gt $SourceUsedSpace) {
        return $true
    } elseif (($DestFreeSpace*0.9) -lt $SourceUsedSpace) {
        return $false
    } else {
        Write-Host 'True/False not working.'
    }
}