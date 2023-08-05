function deleteoldestbackup {
    $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
    Write-Output 'Deletion completed. Creating new backup'
}