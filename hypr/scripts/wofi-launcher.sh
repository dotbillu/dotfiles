#!/bin/bash

# kill existing wofi instances
pkill -x wofi

# launch wofi with 4 lines and icons enabled
wofi --show drun --lines 4 --allow-images