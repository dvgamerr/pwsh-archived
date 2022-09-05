@echo off
SET pwd=%~dp0

pwsh.exe -nol -Command Get-Date >nul
IF %ERRORLEVEL% NEQ 0 (
  ECHO PowerShell Core not found, Installation https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2
  GOTO FAIL
)
ECHO %pwd%
ECHO [pwsh] Initialize...
IF NOT EXIST "%1" (
  ECHO [pwsh] Not exists %1 directory. 
  GOTO FAIL
)

IF NOT EXIST "%2" (
  ECHO [pwsh] Not exists %2 directory. 
  GOTO FAIL
)

pwsh.exe -nol -File "%pwd%/engine.ps1" -from "%1" -to "%2"
GOTO SUCCESS

:FAIL
ECHO [pwsh] Fail, Quit!
GOTO END

:SUCCESS
ECHO [pwsh] Complated.

:END