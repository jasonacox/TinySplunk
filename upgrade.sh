#!/bin/bash
#
# Splunk Server - Startup 
#

echo "Upgrading Splunk..."

echo "stopping..."
docker stop splunk
echo "pulling..."
docker pull splunk/splunk:latest

echo "starting..."
~splunk/watchdog.sh
