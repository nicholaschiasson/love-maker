love-maker
==========
MAKE SOME LOVE WITH LÖVE MAKER

A simple one-click .exe maker for your LÖVE games!

Setup
-----
The current setup only takes lua files from one directory, and that directory is defined in the script as "./src" in relation to your project root directory. If you wish to change this, open the "make (windows).sh" inside a text editor, find where the variable "SRC_DIR" is defined (line 17), and change the path to your liking. Feel free to also change "BIN_DIR" and "PROJ_NAME" as you see fit.

How-to (Windows only so far)
----------------------------
Before running the script, it may be necessary to modify the source directory path. See "Setup" above, if you haven't already.

To build your LÖVE game executable, place this folder into the top of your project tree then run the "make (windows).sh" file!

Also, to make things easier for you and not invade your personal code bubble, I've made this all work from this directory, however, for ease of use, you may want to create a shortcut to the "make (windows).sh" file and place that wherever you'd like.
