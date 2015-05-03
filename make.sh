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

if [ $os == "unknown" ]; then
  echo "Exiting."
  read
  exit
fi

echo "ARCHITECTURE: $arch"

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
BIN_DIR=$PROJ_ROOT/bin

if [ $os == "win" ]; then
  LOVE_ESS=
  if [ $arch == "x86_64" ]; then
    LOVE_ESS=win64
  else
    LOVE_ESS=win32
  fi
  OUT_PRODUCT=$BIN_DIR/$PROJ_NAME.exe

  # Making the Project zip
  7za a -tzip $PROJ_NAME.zip $SRC_DIR/*.lua

  # Changing the zip file extentions to love
  mv $PROJ_NAME.zip $PROJ_NAME.love
  
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
  
  echo "Unimplemented."
  read
  exit
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