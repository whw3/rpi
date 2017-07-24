FROM resin/rpi-raspbian

RUN apt-get update \
 && apt-get upgrade \
 && apt-get install -y -q \
	wget\
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY root /root

ENTRYPOINT ["/bin/bash"]
