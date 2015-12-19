# love-maker.ps1

## This file is only intended for use on Windows systems.

## LOVE version - potentially read through config file and/or retrieved online
$MAJOR = 0
$MINOR = 9
$BUILD = 2
$URL = "https://bitbucket.org/rude/love/downloads/"

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

## Purpose for this conditional is because the first method above for getting
## the system architecture returns as a string either "64-bit" or "32-bit"
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
    $targetos="macosx"
    $arch="x64"
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

## Finding the directory name for ../
$currentPath = [System.Environment]::CurrentDirectory
if ($currentPath)
{
  $parentPath = [System.IO.Path]::GetDirectoryName($currentPath)
  $currentDir = $currentPath.Replace("$parentPath\", "")
}

if ($parentPath)
{
  $grandParentPath = [System.IO.Path]::GetDirectoryName($parentPath)
  $parentDir = $parentPath.Replace("$grandParentPath\", "")
}

$PROJ_ROOT = ".."
$PROJ_NAME = "$parentDir"
$SRC_DIR = "$PROJ_ROOT\src"
$BIN_DIR = "$PROJ_ROOT\bin\$targetos-$arch"

## If a bin directory for the target platform exists, ask to either update or clean.
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

## Ask if we should still go forward with the build.
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

## Making the binaries directory
if (!(test-path -path $BIN_DIR))
{
  new-item -itemtype directory -path $BIN_DIR > $null
}

## Making the Project zip/love file
if (test-path "$PROJ_NAME.love")
{
  rm "$PROJ_NAME.love"
}
Add-Type -A 'System.IO.Compression.FileSystem'
[IO.Compression.ZipFile]::CreateFromDirectory("$SRC_DIR\", "$PROJ_NAME.love")

## Setting platform specific names
if ($targetos -eq "win")
{
  if ($arch -eq "x86_64")
  {
    $LOVE_ESS = "love-$MAJOR.$MINOR.$BUILD-win64"
  }
  else
  {
    $LOVE_ESS = "love-$MAJOR.$MINOR.$BUILD-win32"
  }
  $OUT_PRODUCT = "$BIN_DIR\$PROJ_NAME.exe"
}
elseif ($targetos -eq "macosx")
{
  while (!$COM_NAME)
  {
    $COM_NAME = read-host "Enter a company name"
  }
  $LOVE_ESS = "love-$MAJOR.$MINOR.$BUILD-macosx-x64"
  $OUT_PRODUCT = "$BIN_DIR\$PROJ_NAME.app"
}
elseif ($targetos -eq "linux")
{
  ## TODO: change for the sake of downloading the proper linux files
  $LOVE_ESS = "linux"
  $OUT_PRODUCT = "$BIN_DIR\$PROJ_NAME"
}
else
{
  ## Copying love/zip file
  cp "$PROJ_NAME.love" $BIN_DIR

  ## Removing the love/zip file
  rm "$PROJ_NAME.love"

  ## Copying license
  cp license.txt $BIN_DIR
  
  echo "Unsupported platform."
  write-host "Exiting." -nonewline
  read-host
  return
}
  
## Checking for love files, downloading if not found
if ($targetos -eq "win" -or $targetos -eq "macosx")
{
  if (!(test-path $LOVE_ESS))
  {
    echo "No LOVE installation files found.`nDownloading $LOVE_ESS..."
    $LOVE_DOWNLOAD_URL = "$URL$LOVE_ESS.zip"
    wget $LOVE_DOWNLOAD_URL -UseBasicParsing -OutFile "$LOVE_ESS.zip" > $null
    
    echo "Extracting..."
    [IO.Compression.ZipFile]::ExtractToDirectory("$LOVE_ESS.zip", "temp")
    
    rm -r "$LOVE_ESS.zip"
    mv temp\love* $LOVE_ESS
    rm -r temp
  }
}
elseif ($targetos -eq "linux")
{
  ## TODO: download appropriate linux files
}

## Performing platform specific build
if ($targetos -eq "win")
{
  ## Merging the love executable with the love game
  cmd /c "copy /b $LOVE_ESS\love.exe + $PROJ_NAME.love $OUT_PRODUCT" > $null

  ## Copying libraries
  cp "$LOVE_ESS\*.dll" $BIN_DIR
}
elseif ($targetos -eq "macosx")
{
  ## Copying app data to bin directory
  cp -r "$LOVE_ESS" $OUT_PRODUCT
  cp -r "$PROJ_NAME.love" "$OUT_PRODUCT\Contents\Resources\"

  ## Modifying Info.plist
  $INFOPLIST = "$OUT_PRODUCT\Contents\Info.plist"
  $INFOPLISTCONTENT = Get-Content -raw $INFOPLIST

  $OLDBIDENT = "<string>org.love2d.love</string>"
  $NEWBIDENT = "<string>com.$COM_NAME.$PROJ_NAME</string>"
  $INFOPLISTCONTENT = $INFOPLISTCONTENT.replace($OLDBIDENT, $NEWBIDENT)

  $OLDBNAME = "<string>LÖVE</string>"
  $NEWBNAME = "<string>$PROJ_NAME</string>"
  $INFOPLISTCONTENT = $INFOPLISTCONTENT.replace($OLDBNAME, $NEWBNAME)

  $TOREMOVE = "`t<key>UTExportedTypeDeclarations</key>"
  $ENDFILE = "</dict>`n</plist>CUTHERE`n"
  $INFOPLISTCONTENT = $INFOPLISTCONTENT.replace($TOREMOVE, $ENDFILE)
  
  $INFOPLISTCONTENT = $INFOPLISTCONTENT.substring(0, $INFOPLISTCONTENT.indexof("CUTHERE"))
  
  Set-Content $INFOPLIST $INFOPLISTCONTENT
}
elseif ($targetos -eq "linux")
{
  ## TODO: make linux deb package
  
  cp "$PROJ_NAME.love" $BIN_DIR
}

## Removing the love/zip file
rm "$PROJ_NAME.love"

## Copying license
cp license.txt $BIN_DIR

write-host "`nPress enter to exit." -nonewline
read-host