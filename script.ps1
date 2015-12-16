## Get architecture

## Checking WMI
#arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture

## Using .NET
#### Possibly more reliable in case running in virtual machine or emulator
if ([System.Environment]::Is64BitProcess)
{
  $arch = "64-bit"
}
else
{
  $arch = "32-bit"
}

if ($arch -eq "64-bit")
{
  $arch = "x86_64"
}
else
{
  $arch = "x86"
}

$OSTYPE = (Get-WmiObject Win32_OperatingSystem).Caption
$targetos = "win"
$myos = "win"

echo "OSTYPE: $OSTYPE ($myos)"

echo "ARCHITECTURE: $arch"

echo "Platforms:"
echo "  (1) Windows 64-bit"
echo "  (2) Windows 32-bit"
echo "  (3) Mac OS X"
echo "  (4) Linux"
echo "  (Default) Current Platform"

write-host "`nPress enter to exit." -nonewline
read-host