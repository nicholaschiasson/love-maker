@echo OFF

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set os_arch=32BIT || set os_arch=64BIT

if %os_arch%==32BIT winbash\i686\usr\bin\bash.exe --login -i make.sh
if %os_arch%==64BIT winbash\x86_64\usr\bin\bash.exe --login -i make.sh