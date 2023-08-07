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
        Write-Host 'Deletion will begin in 5 seconds.'
        Start-Sleep -Seconds 10
        $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
        Write-Host 'Deletion completed.'
        return $true
}