#!/bin/bash
#
# Check to see if splunk container is running
#

RUNNING=$(/usr/bin/docker inspect --format="{{.State.Running}}" splunk 2> /dev/null)

echo -n "Checking Splunk Server: "

if [ "$RUNNING" = "true" ]; then
  echo "RUNNING: Splunk container is running."
else
  echo "STOPPED: Splunk container is not running."
fi
echo

docker exec splunk uptime
