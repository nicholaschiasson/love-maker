# love-maker
MAKE SOME LÖVE WITH LOVE MAKER

A simple distribution building script for your LÖVE games!

## Setup
- Drop this project folder under the root directory of your LÖVE project.
- Make sure that all of your code and resources are inside a directory named "src" under the root directory.
- Make sure that the root directory of your project uses the actual name of your project.
- Make sure that you are able to run bash scripts on your machine if you're on anything but Windows or powershell scripts if you are on Windows.
- If the project is under a git repository, make sure to add "love-maker/" to your .gitignore file as well as "bin/" if you haven't already.

## How-to
After having followed the appropriate setup requirements detailed above, to build your distributable LÖVE game, just run the love-maker.bat file if you are on Windows or the love-maker.sh file if you are on any other system.

The scripts prompt the user for some very basic things:
- What platform you want to build the distribution for
  - Options are Windows 64-bit, Windows 32-bit, Mac OS X, and Linux (not implemented yet)
  - Defaults to your running platform
- If a binaries folder already exists for the selected platform, whether you would like to simply update its build or clean and update
  - Clean removes the actual directory, so it's nice to use sometimes
  - Defaults to simple update

If you will be using these scripts for regular compiling while developing (that's what I do) and ALSO aren't in the habit of using a terminal, you may want to copy a shortcut of the script you are using into the binaries directory (or just use a terminal, you lazy ass).

#### Notes
- About the Windows scripts: I mentioned that powershell is required, but the script actually intended to be run is a batch file. There does exist a powershell script in the same directory (if you weren't observant enough to have noticed it yet), but there were some technical details which inclined me to make a batch file with the sole purpose of executing that powershell script. The powershell script actually does do all the work, but I like making things *double-clickable*. It just sits better with me that way.

###### TODO
- Configuration file for SCR_DIR, BIN_DIR, PROJ_NAME, BUILD_MODE, and various other variables
- Implement Linux distribution
- Have script copy a shortcut of the script into the bin folder.
- Don't require to include the Love2D framework in THIS project... download it on first use or something, and check for updates on each use perhaps.
