function createandcopy {
    Write-Host 'Creating new backup.'
    $folderName = (Get-Date).ToString("yyyy-MM-dd-HH-mm-ss")
    $newdir = Join-Path $DestDrive $folderName
    New-Item -ItemType Directory -Path $newdir
    robocopy "$SourceDrive" "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
    Write-Host 'Backup created at' $newdir
}