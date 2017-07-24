# whw3/rpi
Raspbian Base Image -- adds wget support missing from resin/rpi-raspbian

```
FROM resin/rpi-raspbian

RUN apt-get update \
 && apt-get install -y -q \
	wget\
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY root /root

ENTRYPOINT ["/bin/bash"]
```
