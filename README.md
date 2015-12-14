love-maker
==========
MAKE SOME LOVE WITH LÖVE MAKER

A simple distribution building script for your LÖVE games!

Setup
-----
Drop this project folder under the root directory of your LÖVE project. Make sure that all of your code and resources are inside a directory named "src" under the root directory. If you'd prefer another place, you'll need to modify the "SRC_DIR" variable inside the "make.sh" file in this project (not too much trouble). Feel free to also change "BIN_DIR" and "PROJ_NAME" as you see fit. By default, "BIN_DIR" is in a folder named "bin" under the project root and "PROJ_NAME" is just the name of the root directory.

How-to
------
Before running the script, it may be necessary to modify the source directory path. See "Setup" above, if you haven't already.

To build your distributable LÖVE game, place this folder into the top of your project tree then run either the "make.sh" file or the "make (windows).bat" if you are on a windows machine!

Also, to make things easier for you and not invade your personal code bubble, I've made this all work from this directory, however, for ease of use, you may want to create a shortcut to the "make.sh" file and place that wherever you'd like.

Updates
-------
- As I don't have a Mac machine, I can't test on it, however, EVERYTHING SHOULD WORK NOW FOR MAC OS X! HURRAY! Building on a Linux distro was left last (and is still unimplemented) due to apparent complexity.
  - May 4, 2015

TODO
----
- Implement Linux distribution
- Add options for custom project name, source dir, binary dir...
- Have script copy a shortcut of the script into the bin folder.
