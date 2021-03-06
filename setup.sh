#!/bin/bash
#
# Setup for Splunk Server
#

# Edit the password and TZ timezone settings

echo "Start Splunk Server for first time - running..."

docker run \
-d \
-p 8000:8000 \
-p 8088:8088 \
-p 8089:8089 \
-p 8514:514 \
-p 9997:9997 \
-e 'SPLUNK_START_ARGS=--accept-license' \
-e 'SPLUNK_PASSWORD=TinyPassword' \
--name splunk \
--restart unless-stopped \
-e TZ="America/Los_Angeles" \
-v $PWD/var:/opt/splunk/var \
-v $PWD/etc:/opt/splunk/etc \
splunk/splunk:latest

echo "Waiting for Splunk to start..."
sleep 60
docker logs splunk

echo "Done."

