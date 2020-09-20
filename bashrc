
#
# Splunk Tiny Server - Script for bashrc
#

function menu {
    echo "Splunk Commands:"
    echo "   status - splunk server status"
    echo "   logs - splunk server logs"
    echo "   start - start server"
    echo "   stop - stop server"
    echo
}

# Check to see if container is running
RUNNING=$(/usr/bin/docker inspect --format="{{.State.Running}}" splunk 2> /dev/null)
echo -n "Checking Splunk Server: "
if [ "$RUNNING" = "true" ]; then
  echo "RUNNING: Splunk container is running."
else
  echo "STOPPED: Splunk container is not running."
fi
echo

# Set up aliases 
alias start='docker start splunk'
alias stop='docker stop splunk'
alias logs='docker logs splunk'
alias status='~/status.sh'

# Show menu
menu



