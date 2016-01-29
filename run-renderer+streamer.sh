#!/bin/bash

export DISPLAY=":0"
export LD_LIBRARY_PATH=$PWD/bin/lib

# Find out where this script lies
SCRIPT=$(readlink -f $0)
# Absolute path this script is in. /home/user/bin
SCRIPTPATH=`dirname $SCRIPT`

# Go where the script lies (just in case ...)
cd $SCRIPTPATH

# Kill any running session
killall streamagame-renderer64 && sleep 2

# Run Stream-A-Game
./bin/streamagame-streamer $PWD/conf/streamer.conf
