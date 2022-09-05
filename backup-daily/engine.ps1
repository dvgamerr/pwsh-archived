param(
  [String]$from,
  [String]$to
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
  Write-Host "Powershell supported is greater or equal 4.0 (version $($PSVersionTable.PSVersion.Major))" -ForegroundColor Red
  exit 1
}
$dateTime = $(Get-Date -Format "yyyyMMdd-HHmmss")
$folderName = $(Split-Path $from -Leaf)
Write-Host "[pwsh] Backup from '$folderName' to '$to'"
$backupName = $(New-Item -ItemType "Directory" -Path $(Join-Path -Path $to -ChildPath $folderName) -Force)