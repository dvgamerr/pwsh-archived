@echo off
SET backup=%~dp0/backup-daily/backup-dir
SET src=C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\Microsoft
SET dest=D:\dvgamerr\GitHub.com\pwsh-archived\temp

echo --- update source code from github.com ---
git pull origin main
echo ------------------------------------------
cmd /c "%backup% "%src%\NuGet" "%dest%""
cmd /c "%backup% "%src%\VisualStudio" "%dest%""

echo.
PAUSE