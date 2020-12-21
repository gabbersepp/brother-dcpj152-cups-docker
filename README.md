# CUPS print server image for Brother DCP-J152W

## Overview
Docker image including everything you need to turn your good old USB Brother printer into a network printer.

## Run the Cups Server
There are two ways to run the image. Both are tested by myself.

**1. Exposing the device to docker**
```bash
docker run -d -p 631:631 --device=/dev/bus/usb/003/002 cups
```

I think this approach works best if you won't install the printer driver at the host. Be aware of that this has several drawbacks:
+ Not usable in Kubernetes (as far as I know, currently you can't pass `--device` argument)
+ path changes when USB printer is put into another USB port (this is just an assumption but it seems logical)

**2. Exposing the device path**
```bash
docker run -d -p 631:631 --privileged -v /dev/usb/lp0:/dev/usb/lp0 cups
```

This is the way I have choosen because using this way I can utilize Kubernetes. Also it doesn't matter to which USB port I connect my printer. But to get the device path `/dev/usb/lp0` you must install the printer driver on your host system.

>**Note**: I have not so much experience with Linux so this is also just an assumption. I have not tested it more deeply.

## Add printers to the Cups Server
**Using plain docker**: 
+ Navigate to http://<host-ip>:631

**Using kubernetes**:
+ Navigate to http://<host-ip>:30007

Then go to `Administration > Printers > Add Printer`.

>**Note:** The username and password is print/print

## Many thanks to olbat
I first tried the image from [here](https://github.com/olbat/dockerfiles/tree/master/cupsd) but it did not work out of the box. In my case, after all `bugs` where fixed, I neither was able to print something. It seems that using a debian base image does not work with my printer while an ubuntu base image works. So I copied the parts from the Dockerfile that I needed and added my own stuff.

## Links
Here are some links that helped my making this stuff running. This is for all out there that run into the same problems and for me as a reminder.

+ [Give Docker access to a device](https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device)
+ [Using devices in Kubernetes](https://github.com/kubernetes/kubernetes/issues/5607#issuecomment-258195005)
+ [How to setup Cups](https://www.tomshardware.com/how-to/raspberry-pi-print-server)
+ [Printer does not print -> 32 Bit Driver](https://unix.stackexchange.com/a/407966)
+ [32 Bit driver on 64 Bit architecture](https://stackoverflow.com/a/25034137/9809950)
