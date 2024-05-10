if [[ $EUID -ne 0 ]]
then
	echo "Script requires sudo privileges"
	exit
fi

# Install mininet from the source.
git clone https://github.com/mininet/mininet

# Run the installation script.
./mininet/util/install.sh -a

# Check the version number of mininet.
mn --version

# Install packages related to HTTP and DASH
apt-get install apache2 curl x264 ffmpeg gpac iperf iproute

# Kill it on the root system
apache2ctl -k stop

# copy contents of dash.js to apache file
cp -vr ./dashjs /var/www/html

# enable the running of the run file.
chmod +x run.sh
chmod +x run_ff.sh
chmod +x make_dash.sh
chmod +x replace_dash.sh
chmod +x add_qdisc.sh
chmod +x del_qdisc.sh
