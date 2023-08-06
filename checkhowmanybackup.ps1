function checkbackups {
    if ($count -le 1) {
        Write-Host $count 'backup found. Creating new backup'
        return $true
    } elseif ($count -ge 2) {
        Write-Host 'There are' $count 'backups'
        return $false
    }
}