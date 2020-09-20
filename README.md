# TinySplunk

Tools and instructions to build and use a containerized version of Splunk for home

[Splunk](https://www.splunk.com) is a commercial enterprise product.  There is a [Splunk Free](https://www.splunk.com/en_us/download.html) version for personal, ad-hoc search and visualization of data. Splunk Free supports ongoing indexing of small volumes (<500MB/day) of data.  If you go over 500MB/day more than 3 times in a 30 day period, Splunk will continue to index your data, but search will be disabled until you are back down to 3 or fewer times in the 30 day period.

## Setup

This setup assumes a Linux host with docker installed.  

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

    - /home/splunk/var:/opt/splunk/var \
    - /home/splunk/etc:/opt/splunk/etc \

* The script set up port forwarding for the following:

    - 8000 - Main web portal UI
    - 8088 - HTTP Event Collector (HEC) 
    - 8089 - Splunk management port (REST API)
    - 9997 - Indexing receiver endpoint (used by external Universal Forwarders to send data)


## Tools

The following commands are included in this repo:

* start - This will start the container
* status - This will provide the status of the container
* logs - This will display the logs from the container
* upgrade - This will upgrade the container

## Get Data 

Now that Splunk is running, you want to see some data, right?  There are several ways to get data into Splunk.  We will walk through a few of them here:

* *Universal Forwarder* - If you want to send data or log files over from another systems, the Universal Forward is a good way to do that.  There are binaries available for most operating systems, including the ARM processor powered Raspberry Pi!
    * Details coming soon
    * Examples coming soon

* *HTTP Event Collector (HEC)* - You can send data to Splunk to be index via siple HTTP put commands.  This requires that you set up a Splunk HEC token to use
    * Details coming soon
    * Examples coming soon

* *Splunk API* - You can even send data to Splunk through the port 8089 REST API via Splunk SDKs.  
    * Details coming soon
    * Examples coming soon


## References
* https://www.splunk.com/
* https://github.com/georgestarcher/Splunk-Class-httpevent/blob/master/splunk_http_event_collector.py
* https://github.com/jonromero/pyHEC
* https://github.com/georgestarcher/Splunk-Class-httpevent
* Switch to Free License: https://community.splunk.com/t5/Installation/How-do-I-get-a-free-license/m-p/9196

## Notice

This repo is not associated with the Splunk or Splunk, Inc. and is intended as a helpful educational tool to learn Splunk on your home or sandbox network.
Splunk is a registered trademark of Splunk Inc. 