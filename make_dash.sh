#!/bin/bash

rm -r ./video/tmp/
rm -r ./video/out/

# Truncate to 2 minutes to speed up video footage processing.
ffmpeg -i ./video/src/bbb1.mp4 ./video/src/bbb_c.mp4

# Create 3 different video representations
if [[ ! -d ./video/tmp/ ]]
then
	mkdir ./video/tmp
fi

x264 --output ./video/tmp/bbb_2400k.264 --fps 30 --bitrate 2400 ./video/src/bbb_c.mp4 # High
x264 --output ./video/tmp/bbb_1200k.264 --fps 30 --bitrate 1200 ./video/src/bbb_c.mp4 # Med
x264 --output ./video/tmp/bbb_0600k.264 --fps 30 --bitrate 600 ./video/src/bbb_c.mp4 # Low

# Create 3 separate watchable videos
MP4Box -add ./video/tmp/bbb_2400k.264 -fps 30 ./video/tmp/bbb_2400k.mp4
MP4Box -add ./video/tmp/bbb_1200k.264 -fps 30 ./video/tmp/bbb_1200k.mp4
MP4Box -add ./video/tmp/bbb_0600k.264 -fps 30 ./video/tmp/bbb_0600k.mp4

if [[ ! -d ./video/out/ ]]
then
	mkdir ./video/out
fi

# Chucking them in the same command automatically produces a DASH-ed file with multiple representations.
MP4Box -dash 2000 -rap -out ./video/out/bbb_2400k_dash.mpd -segment-name 'bbb_2400k_' ./video/tmp/bbb_2400k.mp4
MP4Box -dash 2000 -rap -out ./video/out/bbb_1200k_dash.mpd -segment-name 'bbb_1200k_' ./video/tmp/bbb_1200k.mp4
MP4Box -dash 2000 -rap -out ./video/out/bbb_0600k_dash.mpd -segment-name 'bbb_0600k_' ./video/tmp/bbb_0600k.mp4

# Combine each MDP file into one big mpd file.
cat ./video/out/bbb_2400k_dash.mpd | awk 'BEGIN{ found=1} /\/AdaptationSet/{found=0} {if (found) print}' >> ./video/out/bbb_dash.mpd
cat ./video/out/bbb_1200k_dash.mpd | awk 'BEGIN{ found=0} /Representation/{found=1} /\/AdaptationSet/{found=0} {if (found) print}' | sed 's/id=\"1\"/id=\"2\"/' >> ./video/out/bbb_dash.mpd
cat ./video/out/bbb_0600k_dash.mpd | awk 'BEGIN{ found=0} /Representation/{found=1} {if (found) print}' | sed 's/id=\"1\"/id=\"3\"/' >> ./video/out/bbb_dash.mpd
