#!/bin/bash

# Truncate to 2 minutes to speed up video footage processing.
ffmpeg -i ./video/src/bbb1.mp4 -t 00:01:00 ./video/src/bbb1_2m.mp4

# Create 3 different video representations
x264 --output ./video/tmp/bbb_2400k.264 --fps 30 --bitrate 2400 ./video/src/bbb1_2m.mp4 # High
x264 --output ./video/tmp/bbb_1200k.264 --fps 30 --bitrate 1200 ./video/src/bbb1_2m.mp4 # Med
x264 --output ./video/tmp/bbb_0600k.264 --fps 30 --bitrate 600 ./video/src/bbb1_2m.mp4 # Low

# Create 3 separate watchable videos
MP4Box -add ./video/tmp/bbb_2400k.264 -fps 30 ./video/tmp/bbb_2400k.mp4
MP4Box -add ./video/tmp/bbb_1200k.264 -fps 30 ./video/tmp/bbb_1200k.mp4
MP4Box -add ./video/tmp/bbb_0600k.264 -fps 30 ./video/tmp/bbb_0600k.mp4

# Chucking them in the same command automatically produces a DASH-ed file with multiple representations.
MP4Box -dash 4000 -rap -out ./video/out/bbb_dash.mpd -segment-name 'bbb_$RepresentationID$_$Number$' ./video/tmp/bbb_2400k.mp4 ./video/tmp/bbb_1200k.mp4 ./video/tmp/bbb_0600k.mp4

