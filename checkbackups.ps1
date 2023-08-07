function checkbackups {
    if ($count -le 1) {
        Write-Host $count 'backup found.'
        return $true
    } elseif ($count -gt 1) {
        Write-Host 'There are' $count 'backups found'
        return $true
    } else {
        Write-Host 'The script has encountered error(s). Please check code.'
        exit
    }
}