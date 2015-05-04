love-maker
==========
MAKE SOME LOVE WITH LÖVE MAKER

A simple distribution building script for your LÖVE games!

Setup
-----
The current setup only takes lua files from one directory, and that directory is defined in the script as "./src" in relation to your project root directory. If you wish to change this, open the "make (windows).sh" inside a text editor, find where the variable "SRC_DIR" is defined, and change the path to your liking. Feel free to also change "BIN_DIR" and "PROJ_NAME" as you see fit.

How-to
------
Before running the script, it may be necessary to modify the source directory path. See "Setup" above, if you haven't already.

To build your distributable LÖVE game, place this folder into the top of your project tree then run the "make.sh" file! Note: of course, this will only work on Windows if you have a MinGW shell like Git Bash, or Cygwin.

Also, to make things easier for you and not invade your personal code bubble, I've made this all work from this directory, however, for ease of use, you may want to create a shortcut to the "make.sh" file and place that wherever you'd like.

Updates
-------
- As I don't have a Mac machine, I can't test on it, however, EVERYTHING SHOULD WORK NOW FOR MAC OS X! HURRAY! Building on a Linux distro was left last (and is still unimplemented) due to apparent complexity.
  - May 4, 2015

TODO
----
- Implement Linux distribution
- Add options for custom project name, source dir, binary dir...
