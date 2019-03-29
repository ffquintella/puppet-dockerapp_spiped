
# dockerapp_spiped


#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with dockerapp_ccm](#setup)
    * [What dockerapp_ccm affects](#what-dockerapp_ccm-affects)
    * [Beginning with dockerapp_ccm](#beginning-with-dockerapp_ccm)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

Spiped is a tool to make secure criptographic communications possible even for apps that doesn't support them. This module installs it using docker and the default structure created on the dockerapp series of modules. 

## Setup

### What dockerapp_ccm affects **OPTIONAL**

This module creates some directories under /srv with the service_name provided

### Beginning with dockerapp_ccm

To use this module you install it and follow the instructions in usage

## Usage

Basic use of the module

```
class {'dockerapp_spiped':
  version => 'xxxx',
  port_in  => '123',
  port_out => '1234',
  ip_out   => '1.1.1.2',
  type     => 'out',
  key      => 'abc123',
}

```



## Limitations

This module is only tested for RedHat 7 derivations and Debian

## Development

Just fork and open change requests. Be shure all the tests are passing using pkd test unit and pdk validate 


