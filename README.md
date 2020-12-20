# brother-dcpj152-cups-docker

Run command:  docker run -d -p 631:631 --device=/dev/bus/usb/003/002 cups
or (with printer drivers installed I think) this works, too: docker run -d -p 631:631 --privileged -v /dev/usb/lp0:/dev/usb/lp0 cups


i installed both brother deb packages on the host, too!
I used https://github.com/olbat/dockerfiles/tree/master/cupsd as base but modified it a bit to fit my needs. 
