#!/bin/sh
#
# Check to see if splunk container is running
#

CONTAINER="splunk"

RUNNING=$(/usr/bin/docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

echo "Checking Splunk Server: "

if [ "$RUNNING" = "true" ]; then
  echo "GOOD: container is running."
  exit 
else
  #echo "NOT GOOD: container is not running."
  wall "Splunk Server Not Running - Restarting container..."
  /usr/bin/docker start splunk
fi


