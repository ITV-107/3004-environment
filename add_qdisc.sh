#!/bin/bash

# Limit the program of the q-disc
tc qdisc add dev $1 root handle 1: tbf rate $2 buffer 6000 limit 8000
