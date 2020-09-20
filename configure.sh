#!/bin/bash
#
# TinySplunk - Set up Linux host for Splunk 
#
# Description
#     This script set ups a Linux host to run the Splunk dockerized container.
#     This will create the splunk user, pull down the TinySplunk tools and 
#     install the Splunk container.
#
# Author
#     Jason A. Cox
#     For more information see https://github.com/jasonacox/TinySplunk
#     Date: 20 Sept 2020

echo "Creating splunk user..."
# Create splunk user and home directory
sudo useradd -m splunk
# Add splunk user to docker group
sudo usermod -aG docker splunk

echo "Switch to splunk user.."
# Switch to splunk user
sudo su - splunk

echo "Installing TinySplunk tools..."
# Pull down TinySplunk utilities
git clone https://github.com/jasonacox/TinySplunk.git

echo "Setting up Splunk docker container..."
# Run Setup to install and configure containerized splunk
./setup.sh

echo "Done."
