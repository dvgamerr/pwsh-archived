@echo off
SET pwd=%~dp0

pwsh.exe -nol -Command Get-Date >nul
IF %ERRORLEVEL% NEQ 0 (
  ECHO PowerShell Core not found, Installation https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2
  GOTO FAIL
)

pwsh.exe -nol -File "%pwd%/engine.ps1" -from ""%1"" -to ""%2""
IF %ERRORLEVEL% NEQ 0 (
  GOTO FAIL
) ELSE (
  GOTO SUCCESS
)

:FAIL
GOTO END

:SUCCESS

:END
ECHO.