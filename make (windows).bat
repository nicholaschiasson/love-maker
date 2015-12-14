@echo OFF

::reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set arch=x86 || set arch=x64
systeminfo | find /i "x64" > NUL && set arch=x86_64 || set arch=x86

set targetos=win
set myos=win

echo OSTYPE: %OS% (%myos%)

echo ARCHITECTURE: %arch%

echo Platforms:
echo   (1) Windows 64-bit
echo   (2) Windows 32-bit
echo   (3) Mac OS X
echo   (4) Linux
echo   (Default) Current Platform

:select_platform
set choice=-1
set /p choice=Select desired platform (0 to exit): 
if not %choice%==-1 (
  if not %choice%==0 (
    if not %choice%==1 (
      if not %choice%==2 (
        if not %choice%==3 (
          if not  %choice%==4 (
            goto select_platform
          )
        )
      )
    )
  )
)

if not %choice%==-1 (
  if %choice%==1 (
    set targetos=win
    set arch=x86_64
    echo Building distribution for Windows 64-bit.
  )
  if %choice%==2 (
    set targetos=win
    set arch=x86
    echo Building distribution for Windows 32-bit.
  )
  if %choice%==3 (
    set targetos=mac
    set arch=x86_64
    echo Building distribution for Mac OS X.
  )
  if %choice%==4 (
    set targetos=linux
    echo Building distribution for Linux.
  )
  if %choice%==0 (
    exit
  )
) else (
  echo Building distribution for current platform.
)
echo.

echo // TODO

echo.
set /p exitvar=Press enter to exit.