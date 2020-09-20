# TinySplunk

TinySplunk is a collection of tools and instructions to build and use a Docker containerized version of Splunk for home and educational use.

What is Splunk? [Splunk](https://www.splunk.com) is a commercial software tool that provides a web-based way to search, monitor and analyze log and event data from computer systems and network devices.  It is a commercial product but they offer a [Splunk Free](https://www.splunk.com/en_us/download.html) version for personal use. The Splunk Free version supports indexing of small volumes (up to 500MB/day).  

I created this repo to chronicle my journey in setting up a home-based Tiny Splunk (free) installation for education and home automation.  I'm including tips, instructions and tools I have found or built along the way. I welcome comments (issues) and pull requests!

## Setup

This setup assumes you are using a Linux host with docker installed.  

```bash
# Create splunk user and home directory
sudo useradd -m splunk

# Add splunk user to docker group
sudo usermod -aG docker splunk

# Switch to splunk user
sudo su - splunk

# Pull down TinySplunk utilities
git clone https://github.com/jasonacox/TinySplunk.git

# Append helper function to .bashrc
cat bashrc >> .bashrc
source bashrc

# Edit the setup.sh for your specific requirements
vim setup.sh

# Run Setup to install and configure containerized splunk
./setup.sh
```

Once this completes, Splunk will be installed and running on the host: 
http://localhost:8000/en-US/app/launcher/home

If you didn't edit the `setup.sh` script the password will be _TinyPassword_. You should change it.

## Details

The `setup.sh` script pulls down the latest splunk container from docker hub.  

* The script will mount the *var* and *etc* folder to local directories to allow configuration and data persistence.

    - /home/splunk/var (host) maps to /opt/splunk/var (container)
    - /home/splunk/etc (host) maps to /opt/splunk/etc (container)

* The script sets up port forwarding for the following:

    - 8000 - Main web portal UI
    - 8088 - HTTP Event Collector (HEC) 
    - 8089 - Splunk management port (REST API)
    - 8514 - Syslog port (514) used for system logging (e.g. servers, network devices)
    - 9997 - Indexing receiver endpoint (used by external Universal Forwarders to send data)

## Tools

The following commands are included in this repo:

* **start** - This will start the container
* **status** - This will provide the status of the container
* **logs** - This will display the logs from the container
* **upgrade** - This will upgrade the container

## Send Data to Splunk

Now that Splunk is running, you want to see some data, right?  There are several ways to get data into Splunk.  We will walk through a few of them here:

### Universal Forwarder - 9997

If you want to send data or log files over from another systems, the Universal Forward is a good way to do that.  There are binaries available for most operating systems, including the ARM processor powered Raspberry Pi!

* Details coming soon
* Examples coming soon

### HTTP Event Collector (HEC) - 8088

You can send data to Splunk via simple HTTP post commands.  This requires that you set up a Splunk HEC token for your scripts to use: 

* Setup - In the Splunk console: Go to _Settings_ -> _Data Input_ -> _HTTP Event Collector_ -> "_New Token_" button.  Copy the token ID for use in your HEC scripts.
* Examples - The following are example scripts you can use to send event data to Splunk via HEC:

    ```bash
    # You can send events via a simple curl http-post command
    curl -k https://localhost:8088/services/collector \
        -H 'Authorization: Splunk xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' \
        -d '{"event":"hello world", "sourcetype": "manual"}'
    ```

* Python Modules - There are several python modules to help with sending events via HEC. This example uses Splunk-HEC (splunk_http_event_collector):

    ```bash
    # Install python module from PyPI
    pip install Splunk-HEC

    # Alternative installation from git - latest version
    pip install git+git://github.com/georgestarcher/Splunk-Class-httpevent.git
    ```

    ```python
    #!/usr/bin/python
    #
    # Event Recorder - Send to Splunk via HEC
    #
    from splunk_http_event_collector import http_event_collector
    import json

    # Configuration and Metadata Settings
    HECKEY = "2bf54cc3-3469-4f3b-bc8c-056bb3dba5bc"
    HECHOST = "10.0.1.26"

    # Setup Splunk HEC Connector
    splunk = http_event_collector(HECKEY, HECHOST)

    # Build payload with metadata information
    event = '{"index": 255, "acolor": "black", "attribute":"lives", "declare":"matter"}'
    payload = {}
    payload.update({"index":"main"})
    payload.update({"sourcetype":"sender-json"})
    payload.update({"source":"http-stream"})
    payload.update({"host":"test"})
    payload.update({"event":event})

    # Send payload
    splunk.sendEvent(payload)
    splunk.flushBatch()
    ```

    Helpful tools for sending HEC messages:
    * [HEC-JSON-Sender.py](tools/HEC-JSON-Sender.py) - Send JSON file as event

### Splunk Management API - 8089

You can even send data to Splunk through the port 8089 REST API via Splunk SDKs.  Note, this only works on the full Splunk Enterprise version (Trial or Licensed) with User and Authentication features enabled.  This is not available in the Splunk Free version.

* The [Splunk SDK for Python](https://dev.splunk.com/enterprise/docs/devtools/python/sdk-python/) includes a client module that makes it easy to send data via the Splunk Management API port.
* Example Usage and Scripts:

    ```bash
    # Install Python SDK
    pip install splunk-sdk
    pip install splunklib
    ```

    ```python
    #!/usr/bin/python
    #  
    # Data Recorder - Splunk Output via Management API
    # 
    import time
    import datetime
    import splunklib.client as client

    # Connect to Splunk API and set metadata for event payload
    service = client.connect(host='localhost',port=8089,username='admin',password='xxxxxxxxxx')
    myindex = service.indexes["main"]
    mysocket = myindex.attach(sourcetype='sensordata',host='sensor')

    # Use a Splunk friendly timestamp and format payload - JSON could be used
    now = datetime.datetime.now()
    iso_time = now.strftime("%D %T.%3m PDT")
    payload = ("time=%s|sensor=%s|voltage=%f|temp=%f|ppm=%s" %
        (iso_time, sensor_number, float(voltage), float(temp), float(ppm)))

    # send output to splunk
    mysocket.send("%s\r\n" % payload)
    mysocket.close()

    ```

## References

* https://www.splunk.com/
* https://github.com/georgestarcher/Splunk-Class-httpevent/blob/master/splunk_http_event_collector.py
* https://github.com/jonromero/pyHEC
* https://github.com/georgestarcher/Splunk-Class-httpevent
* Switch to Free License: https://community.splunk.com/t5/Installation/How-do-I-get-a-free-license/m-p/9196

## Notice

This repo is not associated with the Splunk or Splunk, Inc. and is intended as a helpful educational tool to learn Splunk on your home or sandbox network.
Splunk is a registered trademark of Splunk Inc. 