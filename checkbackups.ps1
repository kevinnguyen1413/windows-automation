function checkbackups {
    if ($count -ge 0) {
        Write-Host 'Backup(s) at destination:' $count
        return $true
    } else {
        Write-Host 'The script has encountered error(s). Please check code.'
        exit
    }
}