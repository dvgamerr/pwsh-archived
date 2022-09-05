@echo off
SET pwd=%~dp0
SET src=C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\Microsoft\NuGet
SET dest=D:\dvgamerr\GitHub.com\pwsh-archived\temp

CALL %pwd%/backup-daily/backup-dir "%src%\15.0" "%dest%"

PAUSE