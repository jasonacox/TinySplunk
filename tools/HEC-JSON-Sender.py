#!/usr/bin/python
"""
TinySplunk Data Recorder 

Description:
    This script reads a JSON file and send the payload to the Splunk
    HTTP Event Collector (HEC)

Setup:
    Update the Configuration details below.

Author: 
    Jason A. Cox
    For more information see https://github.com/jasonacox/TinySplunk
    Date: 20 Sept 2020

"""

from splunk_http_event_collector import http_event_collector
import json
import logging
import sys

# UPDATE Configuration and Metadata Settings
HECKEY = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
HECHOST = "localhost"
INDEX = "main"      # Main is default index - it must exist in Splunk to send
HOSTNAME = "sensor"
SOURCETYPE = "sender-json"
SOURCE = "http-stream"

# Set up logging to get warnings and errors.
logging.basicConfig(format='%(asctime)s %(name)s %(levelname)s %(message)s', datefmt='%Y-%m-%d %H:%M:%S %z')

#
# Main Function
#
def main():
    # Main program block
    if(len(sys.argv) < 2):
        print("Usage: sender.py <JSON-data-file>")
        sys.exit(1)

    sensor_file = sys.argv[1]

    # Setup Splunk HEC Connector
    splunk = http_event_collector(HECKEY, HECHOST)
    splunk.log.setLevel(logging.ERROR)

    # Perform a HEC endpoint reachable check
    hec_reachable = splunk.check_connectivity()
    if not hec_reachable:
        print("ERROR: HEC endpoint unreachable.")
        sys.exit(1)

    # Read line of file and break apart JSON into event items
    event = {}
    try:
        file = open(sensor_file,"r")
        data = json.load(file)
    except:
        print("ERROR: Unable to open %s" % sensor_file)
        sys.exit(1)
    try:
        for k, v in data.items():
            event.update({k:v})

        # Build payload with metadata information
        payload = {}
        payload.update({"index":INDEX})
        payload.update({"sourcetype":SOURCETYPE})
        payload.update({"source":SOURCE})
        payload.update({"host":HOSTNAME})
        payload.update({"event":event})
        # Send payload
        splunk.sendEvent(payload)
        splunk.flushBatch()
    except:
        print("ERROR: Unable to parse file %s" % sensor_file)

if __name__ == '__main__':

    try:
        main()
    except KeyboardInterrupt:
        pass