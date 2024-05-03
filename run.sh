if [[ $EUID -ne 0 ]]
then
	echo "Script requires root privileges to run"
	exit
fi

python 3004-topo.py
mn -c
