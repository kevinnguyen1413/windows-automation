function deleteoldestbackup {
    if ((checkenoughspace) -eq $false -And (checkhowmanybackup -eq $true)) {
        $allFolders | Sort-Object CreationTime -Descending | Select-Object -Skip 1 | Remove-Item -Recurse -Force
        Write-Output 'Deletion completed. Creating new backup'
    } else {
        Write-Output 'The script has encountered error(s). Please check code.'
        exit
    }
}