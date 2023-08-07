function deleteoldestbackup {
        if ($count -le 1) {
            Write-Output 'There is $count backup. No need to delete.'
            return $false
        }
    
        Write-Output 'There are $count backups but not enough drive capacity. Deletion will begin in 5 seconds.'
        Start-Sleep -Seconds 5    
        $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
        Write-Output 'Deletion completed.'
        return $true
    }
    