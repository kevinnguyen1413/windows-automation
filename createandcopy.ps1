function createandcopy {
    $folderName = (Get-Date).tostring("yyyy-MM-dd-hh-mm-ss")
    New-Item -ItemType Directory -Path $DestDrive -Name $folderName
    $newdir = $DestDrive + $folderName
    robocopy $SourceDrive "$newdir" /E /A-:SHA /XA:H /XD "$newdir"
    Write-Output 'Backup created at'$newdir
}