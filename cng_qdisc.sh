#!/bin/bash

# Limit the program of the q-disc
tc qdisc change dev $1 root handle 1: tbf rate $2 buffer 1600 limit 3000

