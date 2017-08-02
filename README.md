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

COPY root /root

ENTRYPOINT ["/bin/bash"]
```
