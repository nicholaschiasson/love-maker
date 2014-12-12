#!/bin/bash

PATH_ARR=$(echo $(pwd) | tr "/" "\n")

# Finding the directory name for ../
p1=
p2=
for i in $PATH_ARR
do
  p2=$p1
  p1=$i
done

LOVE_ESS=.
PROJ_ROOT=..
PROJ_NAME=$p2
SRC_DIR=$PROJ_ROOT/src
BIN_DIR=$PROJ_ROOT/bin
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

cat $LOVE_ESS/love.exe > $OUT_PRODUCT
cat $PROJ_NAME.love >> $OUT_PRODUCT

# Removing the love/zip file
rm $PROJ_NAME.love

# Copying dll files
cp $LOVE_ESS/*.dll $BIN_DIR