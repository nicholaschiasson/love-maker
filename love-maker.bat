:: love-maker.bat

:: This batch file exists only for the purpose of executing the powershell file
:: named love-maker.ps1. This file is only intended for use on Windows systems.

@echo OFF

:: Name of powershell script to run. Make sure name matches name of powershell
:: script found in this directory.
set powershell_script=love-maker.ps1

if exist %powershell_script% (
  powershell.exe -executionpolicy remotesigned -File %powershell_script%
) else (
  echo Powershell script "%powershell_script%" not found.
  echo.
  set /p exitvar=Press enter to exit.
  exit
)