# love-maker.ps1

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

## Ask for the target platform
$choice = "-1"
while ($choice -and $choice -ne "0" -and $choice -ne "1" -and
  $choice -ne "2" -and $choice -ne "3" -and $choice -ne "4")
{
  $choice = read-host "Select desired platform (0 to exit)"
}

if ($choice)
{
  if ($choice -eq "1")
  {
    $targetos="win"
    $arch="x86_64"
    echo "Building distribution for Windows 64-bit."
  }
  elseif ($choice -eq "2")
  {
    $targetos="win"
    $arch="x86"
    echo "Building distribution for Windows 32-bit."
  }
  elseif ($choice -eq "3")
  {
    $targetos="mac"
    $arch="x86_64"
    echo "Building distribution for Mac OS X."
  }
  elseif ($choice -eq "4")
  {
    $targetos="linux"
    echo "Building distribution for Linux."
  }
  elseif ($choice -eq "0")
  {
    return
  }
}
else
{
  echo "Building distribution for current platform."
}
write-host

$currentPath = [System.Environment]::CurrentDirectory
if ($currentPath)
{
  $parentPath = [System.IO.Path]::GetDirectoryName($currentPath)
  $currentDir = $currentPath.Replace($parentPath + "\", "")
}

if ($parentPath)
{
  $grandParentPath = [System.IO.Path]::GetDirectoryName($parentPath)
  $parentDir = $parentPath.Replace($grandParentPath + "\", "")
}

$PROJ_ROOT = ".."
$PROJ_NAME = $parentDir
$SRC_DIR = $PROJ_ROOT + "/src"
$BIN_DIR = $PROJ_ROOT + "/bin/" + $targetos + "-" + $arch

# If a bin directory for the target platform exists, ask to either update or clean.
if (test-path -path $BIN_DIR)
{
  $choice = "-1"
  echo "A distribution for this platform already exists."
  while ($choice -and $choice -ne "y" -and $choice -ne "n")
  {
    $choice = read-host "Would you like to update it (y) or clean and update (n)? (default y/n)"
  }
  if ($choice -eq "n")
  {
    rm -r $BIN_DIR
  }
}

# Ask if we should still go forward with the build.
$choice = "-1"
echo "Build will start."
while ($choice -and $choice -ne "y" -and $choice -ne "n")
{
  $choice = read-host "Do you want to continue? (default y/n)"
}
if ($choice -eq "n")
{
  return
}

# Creating bin directory in case it doesn't exist.
if (!(test-path -path $BIN_DIR))
{
    new-item -itemtype directory -path $BIN_DIR > $null
}



write-host "`nPress enter to exit." -nonewline
read-host