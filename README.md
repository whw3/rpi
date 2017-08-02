# whw3/rpi
Raspbian Base Image -- adds wget support missing from resin/rpi-raspbian

Also adds properly configured Timezone setup. Can be reconfigured inside container by running ***/root/bin/tzconfig***
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
# whw3/rpi-s6
Same Raspbian Base Image as above, but also adds [s6-overlay](https://github.com/just-containers/s6-overlay) 
