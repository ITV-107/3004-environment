#!/usr/bin/env python

from mininet.net import Mininet
from mininet.node import Controller, RemoteController, OVSController
from mininet.node import CPULimitedHost, Host, Node
from mininet.node import OVSKernelSwitch, UserSwitch
from mininet.node import IVSSwitch
from mininet.cli import CLI
from mininet.log import setLogLevel, info
from mininet.link import TCLink, Intf
from subprocess import call
from time import sleep
import sys

# "bandwidth" controls the bottleneck link between the applications
def myNetwork():

    # Initialise the mininet
    net = Mininet( topo=None,
                   build=False,
                   ipBase='10.0.0.0/8')

    # Initialise the controller - this runs on a separate VM
    info( '*** Adding controller\n' )
    c0=net.addController(name='c0',
                      controller=RemoteController,
                      ip='192.168.10.226',
                      protocol='tcp',
                      port=6633)

    info( '*** Add switches\n')
    s1 = net.addSwitch('s1', cls=OVSKernelSwitch)
    s2 = net.addSwitch('s2', cls=OVSKernelSwitch)
    s3 = net.addSwitch('s3', cls=OVSKernelSwitch)

    info( '*** Add hosts\n')
    h1 = net.addHost('h1', cls=Host, ip='10.0.0.1', defaultRoute=None)
    h2 = net.addHost('h2', cls=Host, ip='10.0.0.2', defaultRoute=None)

    info( '*** Add links\n')
    net.addLink(s1, h1)
    net.addLink(s1, s2)

    # The bottleneck link is here
    # because it represents the "last mile"
    # that has repeatedly bad connections.
    net.addLink(s2, s3, cls=TCLink)
    net.addLink(s3, h2, cls=TCLink)

    # Start the network
    info( '*** Starting network\n')
    net.build()
    info( '*** Starting controllers\n')
    for controller in net.controllers:
        controller.start()

    info( '*** Starting switches\n')
    net.get('s1').start([c0])
    net.get('s2').start([c0])
    net.get('s3').start([c0])
    net.start()

    info( '*** Post configure switches and hosts\n')
    print(h1.cmd('apache2ctl -k start'))
    h1.cmd('iperf -s &')
    h2.cmd('./run_ff.sh &')
    CLI(net)

if __name__ == "__main__":
    setLogLevel('info')
    myNetwork()
