function createandcopy {
    if ((checkenoughspace) -eq $true -And (checkhowmanybackup -eq $true)) {
        Write-Output 'Creating new backup.'
        $folderName = (Get-Date).tostring("yyyy-MM-dd-hh-mm-ss")
        New-Item -ItemType Directory -Path $DestDrive -Name $folderName
        $newdir = $DestDrive + $folderName
        robocopy $SourceDrive "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
        Write-Output 'Backup created at'$newdir
    } elseif ((deleteoldestbackup) -eq $true) {
        Write-Output 'Creating new backup'
        $folderName = (Get-Date).tostring("yyyy-MM-dd-hh-mm-ss")
        New-Item -ItemType Directory -Path $DestDrive -Name $folderName
        $newdir = $DestDrive + $folderName
        robocopy $SourceDrive "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
        Write-Output 'Backup created at'$newdir
    } else {
        Write-Output 'The script has encountered error(s). Please check code.'
        exit 
    }
}