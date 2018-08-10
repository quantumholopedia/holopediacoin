# nightly.sh - pull a copy of turtlecoin-development 
# and put it inside a timestamped folder.
# rock made this
#!/usr/bin/env bash

# This is the folder where your source code snapshots will go
# when you are done building.
sourcefolder=~/Source/turtle-dev-build-$(date '+%Y-%m-%d-%H-%M')

# Clear the workspace
clear

# Move to the Source directory
# If you get an error here, run "mkdir ~/Source"
echo -e "== MOVING TO ~/Source"
cd ~/Source/

# What's in the Source folder? Let's see.
ls -al

# Clone a copy of the TurtleCoin source code
echo -e "\n\n\n== CLONING TurtleCoin in $sourcefolder"

# By default we always push to the development branch, so if you 
# want a nightly build, this is your best option. However, if you
# just want to grab the last release build, I think you can clone
# master branch instead, and it will get the source from the last
# time that we merged development to master, which normally only
# happens when we create a version release.
git clone -b development https://github.com/turtlecoin/turtlecoin $sourcefolder
cd $sourcefolder
ls -al

# To compile, we make a build directory. This is mostly for 
# vanity and cleanliness. You could build directly into the
# source code folder, but it looks messy and this way makes
# it easier to see all of your files.
mkdir -p $sourcefolder/build && cd $sourcefolder/build
ls -al

# Move into the work area and start compiling. If you don't want 
# to use all of your cores to compile this, or if you get errors 
# about not enough ram/swap, you can remove the -j`nproc` from 
# the make command.
echo -e "\n\n\n== BUILDING TurtleCoin"
cmake .. && make
cd src
ls -al

# Take everything we've compiled, and put it in a zip ready for
# distribution. We should also include the LICENSE file in this 
# zip file just in case.
echo -e "\n\n\n== COMPRESSING BINARIES"
wget https://raw.githubusercontent.com/turtlecoin/turtlecoin/development/LICENSE
zip turtlecoin-dev-bin-$(date +%F)-linux.zip miner LICENSE zedwallet TurtleCoind turtle-service

# Create directories to keep always-up-to-date binaries for 
# TRTL Network files. Ideally, your bashrc has aliases to run
# from this folder, or you can add it to your $PATH.
mkdir ~/.Crypto/{Athena,TurtleCoin,Karai}
mkdir ~/Binaries

# Move the zip we created to the Binaries snapshot folder.
mv *.zip ~/Binaries/
cd ~/Binaries

# Copy the binaries to the folder we just created for them.
# Remove the files that are already there just in case.
rm ~/.Crypto/TurtleCoin/miner
rm ~/.Crypto/TurtleCoin/zedwallet
rm ~/.Crypto/TurtleCoin/TurtleCoind
rm ~/.Crypto/TurtleCoin/turtle-service
cp miner ~/.Crypto/TurtleCoin/miner
cp zedwallet ~/.Crypto/TurtleCoin/zedwallet
cp TurtleCoind ~/.Crypto/TurtleCoin/TurtleCoind
cp turtle-service ~/.Crypto/TurtleCoin/turtle-service



