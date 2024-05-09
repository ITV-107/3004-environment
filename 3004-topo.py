#!/usr/bin/python
from mininet.net import Mininet
from mininet.node import Controller, OVSKernelSwitch, RemoteController
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import setLogLevel, info
import sys

def myNetwork(ip_str):
    net = Mininet(topo=None, build=False)
    info( '*** Add controller\n')
    net.addController(name='c0',
                      controller=RemoteController,
                      ip=ip_str,
                      port=6633)
    
    info( '*** Add switches (3 in a row)\n')
    s1 = net.addSwitch('s1')
    s2 = net.addSwitch('s2')
    s3 = net.addSwitch('s3')
    
    info( '*** Add hosts\n')
    h1 = net.addHost('h1')
    h2 = net.addHost('h2')

    info( '*** Add all links, including bottleneck near s3\n')
    net.addLink(h1, s1)
    net.addLink(s1, s2)
    net.addLink(s2, s3)
    net.addLink(s3, h2, cls=TCLink)

    info( '*** Starting network\n')
    net.start()

    info( '*** Starting DASH server\n')
    h1.cmd('apache2ctl -k start') # This should be content downloaded from H1
    h2.cmd('iperf -sD') # It should download content from the client on H1
    CLI(net)
    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    ip_config = sys.argv[1]
    myNetwork(ip_config)
