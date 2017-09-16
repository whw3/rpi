# whw3/rpi
Raspbian Base Image -- adds wget support missing from resin/rpi-raspbian

Also adds properly configured Timezone setup. Can be reconfigured inside container by running ***/root/bin/tzconfig***

# whw3/rpi-s6
Same Raspbian Base Image as above, but also adds [s6-overlay](https://github.com/just-containers/s6-overlay) 

Repository depreciated in favor of [whw3/baseimage](https://github.com/whw3/baseimage)
