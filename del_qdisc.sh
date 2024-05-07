#!/bin/bash

# Limit the program of the q-disc
tc qdisc del dev $1 root

#Check the bandwidth change with iperf
iperf -c 10.0.0.1
