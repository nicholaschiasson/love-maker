#!/bin/bash

os=""
arch=$(uname -m)

case "$OSTYPE" in
  *bsd*)     os="bsd" ;;
  cygwin*)  os="win" ;;
  darwin*)  os="mac" ;;
  linux*)   os="linux" ;;
  msys*)    os="win" ;;
  solaris*) os="solaris" ;;
  *)        os="unknown" ;;
esac

echo "OSTYPE: $OSTYPE ($os)"

echo "ARCHITECTURE: $arch"

echo "Platforms:"
echo "  (1) Windows 64-bit"
echo "  (2) Windows 32-bit"
echo "  (3) Mac OS X"
echo "  (4) Linux"
echo "  (Enter) Current Platform"

choice="-1"
while [ $choice != "0" ] && [ $choice != "1" ] && [ $choice != "2" ] &&
  [ $choice != "3" ] && [ $choice != "4" ]; do
  read -p "Select desired platform (0 to exit): " choice
  if [ -z $choice ]; then
    break
  fi
done

if [ ! -z $choice ]; then
  if [ $choice == "1" ]; then
    os="win"
    arch="x86_64"
    echo "Building distribution for Windows 64-bit."
  elif [ $choice == "2" ]; then
    os="win"
    arch="x86"
    echo "Building distribution for Windows 32-bit."
  elif [ $choice == "3" ]; then
    os="mac"
    echo "Building distribution for Mac OS X."
  elif [ $choice == "4" ]; then
    os="linux"
    echo "Building distribution for Linux."
  elif [ $choice == "0" ]; then
    exit
  fi
else
  echo "Building distribution for current platform."
fi
echo

PATH_ARR=$(echo $(pwd) | tr "/" "\n")

# Finding the directory name for ../
p1=
p2=
for i in $PATH_ARR
do
  p2=$p1
  p1=$i
done

PROJ_ROOT=..
PROJ_NAME=$p2
SRC_DIR=$PROJ_ROOT/src
BIN_DIR=$PROJ_ROOT/bin/$os-$arch

if [ -e $BIN_DIR ]; then
  choice="-1"
  echo "A distribution for this platform already exists."
  while [ $choice != "y" ] && [ $choice != "n" ]; do
    read -p "Would you like to clean? (y/n): " choice
  done
  if [ $choice == "y" ]; then
    rm -rf $BIN_DIR
  fi
fi

choice="-1"
echo "Build will start."
while [ $choice != "y" ] && [ $choice != "n" ]; do
  read -p "Do you want to continue? (y/n): " choice
done
if [ $choice == "n" ]; then
  exit
fi

if [ $os == "win" ]; then
  LOVE_ESS=
  if [ $arch == "x86_64" ]; then
    LOVE_ESS=win64
  else
    LOVE_ESS=win32
  fi
  OUT_PRODUCT=$BIN_DIR/$PROJ_NAME.exe

  # Making the Project zip/love file
  7za a -tzip $PROJ_NAME.love $SRC_DIR/*.lua

  # Making the binaries directory
  ARR=$(echo $BIN_DIR | tr "/" "\n")
  CURR_DIR=
  for i in $ARR
  do
    CURR_DIR=$CURR_DIR$i/
    if [ ! -e $CURR_DIR ]; then
      mkdir $CURR_DIR
    fi
  done

  # Making the executable
  if [ ! -e $OUT_PRODUCT ]; then
    touch $OUT_PRODUCT
  fi

  cat $LOVE_ESS/love.exe $PROJ_NAME.love > $OUT_PRODUCT

  # Copying dll files
  cp $LOVE_ESS/*.dll $BIN_DIR
elif [ $os == "mac" ]; then
  LOVE_ESS=macosx
  OUT_PRODUCT=$BIN_DIR/$PROJ_NAME.app

  # Making the Project zip
  zip -9 -q -r $PROJ_NAME.love $SRC_DIR

  # Making the binaries directory
  ARR=$(echo $BIN_DIR | tr "/" "\n")
  CURR_DIR=
  for i in $ARR
  do
    CURR_DIR=$CURR_DIR$i/
    if [ ! -e $CURR_DIR ]; then
      mkdir $CURR_DIR
    fi
  done

  cp -r $LOVE_ESS/love.app $OUT_PRODUCT

  echo "Unimplemented."
elif [ $os == "linux" ]; then
  LOVE_ESS=linux
  OUT_PRODUCT=$BIN_DIR/$PROJ_NAME

  # Making the Project zip
  zip -9 -q -r $PROJ_NAME.love $SRC_DIR

  # Making the binaries directory
  ARR=$(echo $BIN_DIR | tr "/" "\n")
  CURR_DIR=
  for i in $ARR
  do
    CURR_DIR=$CURR_DIR$i/
    if [ ! -e $CURR_DIR ]; then
      mkdir $CURR_DIR
    fi
  done

  # Making the executable
  if [ ! -e $OUT_PRODUCT ]; then
    touch $OUT_PRODUCT
  fi

  cat $LOVE_ESS/love.exe $PROJ_NAME.love > $OUT_PRODUCT
else
  echo "Unsupported platform."
  echo "Exiting."
  read
  exit
fi

# Removing the love/zip file
rm $PROJ_NAME.love

# Copying license
cp license.txt $BIN_DIR

echo
echo "Press enter to exit."
read
