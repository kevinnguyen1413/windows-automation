

function main {
    checkanddeletebackup
}

function checkanddeletebackup {
    if ($count -le 1) {
        Write-Host $count 'backup found. Creating new backup'
        createandcopy
    } elseif ($count -ge 2) {
        Write-Host 'There are' $count 'backups. Checking for sufficient free space to create backup number' ($count+1)
        checkenoughspace
        if((checkenoughspace) -eq $true -And (checkhowmanybackup) -eq $true) {
            createandcopy
        } elseif ((checkenoughspace) -ne $true)  {
            deleteoldestbackup
            createandcopy
            exit
        }
    } else {
        Write-Host 'Please check the code for errors'
        exit
    }
}