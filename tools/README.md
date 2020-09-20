# TinySplunk - Tools

TinySplunk is a collection of tools to build and use a Docker containerized version of Splunk for home and educational use.

## HTTP Event Collector (HEC) Tools

You can send data to Splunk to be index via siple HTTP post commands.  This requires that you set up a Splunk HEC token for your scripts to use: 

* Setup - In the Splunk console: Go to _Settings_ -> _Data Input_ -> _HTTP Event Collector_ -> "_New Token_" button.  Copy the token ID for use in your HEC scripts.

### HEC-JSON-Sender.py

The [HEC-JSON-Sender.py](HEC-JSON-Sender.py) script reads a JSON file and send that as an event payload to the Splunk HEC endpoint.

* Edit the [HEC-JSON-Sender.py](HEC-JSON-Sender.py) file with the correct server and metadata settings.
