# whw3/rpi
Raspbian Base Image -- adds wget support missing from resin/rpi-raspbian

Also adds properly configured Timezone setup. Can be reconfigured inside container by running ***/root/bin/tzconfig***

# whw3/rpi-s6
Same Raspbian Base Image as above, but also adds [s6-overlay](https://github.com/just-containers/s6-overlay) 

## Install ##
### Assumptions
* home for docker build images is ***/srv/docker***

To build the image(s) run ***/srv/docker/rpi/build.sh***
```
mkdir -p /srv/docker
cd /srv/docker
git clone https://github.com/whw3/rpi.git
cd rpi
chmod 0700 build.sh
./build.sh
```
***Dockerfile***
```
FROM resin/rpi-raspbian
RUN apt-get update\
 && apt-get upgrade\ 
 && apt-get install -y -q wget bash-completion nano tzdata\
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY root /root/
RUN chmod 0700 /root/bin/tzconfig && echo "America/Chicago" > /etc/timezone;\
 cp /usr/share/zoneinfo/America/Chicago /etc/localtime && exit 0 ; exit 1
CMD ["/bin/bash"]
```
