param([String]$from, [String]$to)

Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

function write-msg($tag, $color,$msg) {
  Write-Host $(Get-Date -Format "HH:mm:ss.ff") -ForegroundColor "DarkGray" -NoNewline
  Write-Host " [$tag] " -ForegroundColor $color -NoNewline
  Write-Host $msg -ForegroundColor $color
}

IF ($PSVersionTable.PSVersion.Major -lt 7) {
  Write-Host "Powershell supported is greater or equal 4.0 (version $($PSVersionTable.PSVersion.Major))" -ForegroundColor Red
  exit 1
}

$from = $from.Trim('"')
$to = $to.Trim('"')
write-msg "pwsh" "Gray" "Initialize..."
IF ((Test-Path -Path $from -PathType Container) -eq $False) {
  write-msg "pwsh" "Red" "Not exists $from"
  Write-Error "Directory not exists. " -ErrorAction Stop
}
IF ((Test-Path -Path $to -PathType Container) -eq $False) {
  write-msg "pwsh" "Red" "Not exists $to"
  Write-Error "Directory not exists. " -ErrorAction Stop
}

$dateTime = $(Get-Date -Format "yyyyMMdd-HHmmss")
[String]$folderName = $(Split-Path $from -Leaf)

$log = $(Join-Path -Path $to -ChildPath "$($dateTime)_$($folderName).txt")
$toDir = $(Join-Path -Path $to -ChildPath $(Get-Date -Format "yyyyMMdd") -AdditionalChildPath $folderName)
New-Item -ItemType "Directory" -Path $toDir -Force > $null

$lastBackup = $(Get-ChildItem -Path $toDir -Directory | sort Name | select -last 1)

$fileFromBackup = $(Get-ChildItem -Path $from -Recurse -File | Sort -desc)
$fileToBackup = $(Get-ChildItem -Path $lastBackup -Recurse -File | Sort -desc)

Write-Output """fullname"",""size""" > $log
$intSize = 0
foreach ($file in $fileFromBackup) {
  $intSize = $intSize + $file.Length
  Write-Output """$($file.FullName.replace($from,''))"",""$($file.Length)""" >> $log
}

If ($fileToBackup -ne $null) {
  write-msg pwsh "Gray" "Compare File changing..."

  foreach ($toFile in $fileToBackup) {
    $pathTo = $toFile.FullName.replace($lastBackup,'')
    $found = $False
    $foundFile = $null
    foreach ($fromFile in $fileFromBackup) {
      $foundFile = $fromFile
      $pathFrom = $fromFile.FullName.replace($from,'')
      If ($pathFrom -eq $pathTo) {
        $found = $True
        If ($fromFile.Length -ne $toFile.Length){
          write-msg "updated" "Blue" $pathFrom
        }
        break
      }
    }
    If ($found -eq $False) {
      write-msg "remove" "Red" $pathTo
    }
  }
}

write-msg "pwsh" "Gray" "Backup from '$folderName' to '$to'..."
Copy-Item $from -Destination $(Join-Path -Path $to -ChildPath $(Get-Date -Format "yyyyMMdd")) -Recurse -Force
# $i = 0
# foreach ($file in $fileFromBackup) {
#   $i++
#   Write-Progress -activity "$(Get-Date -Format "HH:mm:ss.ff") [copy]" -status $file.FullName.replace($from,'') -PercentComplete ($i * 100 / $fileFromBackup.Length)
#   $dir = $file.FullName.replace($from,'').replace($file.Name,'')
#   IF ((Test-Path -Path $(Join-Path -Path $toDir -ChildPath $dir) -PathType Container) -eq $False) {
#     New-Item -ItemType "Directory" -Path $(Join-Path -Path $toDir -ChildPath $dir) -Force > $null
#   }
#   Copy-Item $file.FullName -Destination $(Join-Path -Path $toDir -ChildPath $dir -AdditionalChildPath $file.Name) -Force
# }
write-msg "pwsh" "Gray" "Total file: $($fileFromBackup.Length)"
write-msg "pwsh" "Gray" "Total size: $([Math]::Round($intSize/1MB,4,[MidPointRounding]::AwayFromZero)) MB."

write-msg "pwsh" "Green" "Backup complated."