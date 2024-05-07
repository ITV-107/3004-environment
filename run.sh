#!/bin/bash
if [[ $EUID -ne 0 ]]
then
	echo "Script requires root privileges to run"
	exit
fi

apache2ctl -k stop
python 3004-topo.py $1
mn -c
