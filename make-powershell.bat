@echo OFF

::Name of powershell script to run. Make sure name matches name of powershell script found in this directory
set powershell_script=script.ps1

if exist %powershell_script% (
  powershell.exe -executionpolicy remotesigned -File %powershell_script%
) else (
  echo Powershell script %powershell_script% not found.
  echo.
  set /p exitvar=Press enter to exit.
  exit
)