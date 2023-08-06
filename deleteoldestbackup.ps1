function deleteoldestbackup {
        Write-Output 'There are' $count 'backups but not enough drive capacity. Deletion will begin in 5 seconds. Press Ctrl+C if you want to stop now.'
        Start-Sleep -Seconds 5
        $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
        Write-Output 'Deletion completed.'
        return $true
}