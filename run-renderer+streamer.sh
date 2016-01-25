#!/bin/bash

export DISPLAY=":0"

export LD_LIBRARY_PATH=$PWD/lib

killall streamagame-renderer64 && sleep 2

# Run GA
./streaming/bin/ga-server-event-driven $PWD/conf/streaming.conf
