#!/bin/bash
#
# Download from nvidia packages to build GPU containers for balena
# Davidnet (david@kiwicampus.com)
set -euo pipefail

nvpmodel -m 0
/usr/src/app/nvidia_utils/jetson_clocks.sh

xinit &
wget https://s3.amazonaws.com/kiwibot/eyes.mp4
while true ; do gst-launch-1.0 filesrc location=eyes.mp4 !  qtdemux name=demux demux.video_0 ! queue ! h264parse ! omxh264dec !  nvoverlaysink display-id=0 -e ; done
