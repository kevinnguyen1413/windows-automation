function checkbackups {
    if ($count -le 1) {
        Write-Host $count 'backup found.'
        return $true
    } elseif ($count -ge 2) {
        Write-Host 'There are' $count 'backups.'
        return $true
    }
}