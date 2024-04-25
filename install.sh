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
