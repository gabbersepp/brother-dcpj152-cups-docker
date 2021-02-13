FROM ubuntu:latest
RUN export DEBIAN_FRONTEND=noninteractive && \
apt-get update \
&& apt-get install -y \
  sudo \
  whois \
  cups \
  wget \
  gcc-multilib \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir /var/spool/lpd/
RUN wget https://download.brother.com/welcome/dlf006980/dcpj152wlpr-3.0.0-1.i386.deb \
    &&  dpkg -i --force-all ./dcpj152wlpr-3.0.0-1.i386.deb
RUN wget https://download.brother.com/welcome/dlf006982/dcpj152wcupswrapper-3.0.0-1.i386.deb \
    &&  dpkg  -i  --force-all ./dcpj152wcupswrapper-3.0.0-1.i386.deb

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Configure the service's to be reachable
RUN /usr/sbin/cupsd \
  && while [ ! -f /var/run/cups/cupsd.pid ]; do sleep 1; done \
  && cupsctl --remote-admin --remote-any --share-printers \
  && kill $(cat /var/run/cups/cupsd.pid)

# Patch the default configuration file to only enable encryption if requested
RUN sed -e '0,/^</s//DefaultEncryption IfRequested\n&/' -i /etc/cups/cupsd.conf

COPY ["./printers.conf", "./printers.conf.O", "/etc/cups/"]
COPY ./ppd /etc/cups/ppd

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]