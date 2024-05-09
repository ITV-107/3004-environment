#!/bin/bash

# Limit the program of the q-disc
tc qdisc delete dev $1 root
