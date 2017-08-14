#/bin/bash
if  [[ "$(which jq)" = "" ]]; then
    whiptail --title "Missing Required File" --yesno "jq is required for this script to function.\nShould I install it for you?" 8 48 "$TZ"  3>&1 1>&2 2>&3
    exitstatus=$?; if [ $exitstatus = 1 ]; then exit 1; fi
    apt-get update
    apt-get install -y jq
fi
TZ=""
while [ "$TZ" = "" ]
do    
    TZ="America/Chicago"
    [[ -f TIMEZONE ]] && source TIMEZONE
    TZ=$(whiptail --inputbox "Default timezone" 8 78 "$TZ" --title "Alpine Builder" 3>&1 1>&2 2>&3)
    exitstatus=$?; if [ $exitstatus = 1 ]; then exit 1; fi
    if [[ ! "$(grep -c -w "$TZ" zone.csv )" = "1" ]]; then
        TIMEZONES=( $(cat root/zone.csv | cut -d, -f3|sort| sed 's/\"//g'|awk '!/^ / && NF {print $1 " [] off"}') )
        TZ=$(whiptail --title "Timezone Config" --radiolist --separate-output "Select Timezone" 20 48 12 "${TIMEZONES[@]}" 3>&1 1>&2 2>&3)    
        exitstatus=$?; if [ $exitstatus = 1 ]; then exit 1; fi
    fi
done
echo 'export TZ="$TZ"' > TIMEZONE

[[ -f s6-tags.json ]] && rm s6-tags.json
wget -qO s6-tags.json https://api.github.com/repos/just-containers/s6-overlay/tags
eval "$(jq -r '.[0] | @sh "S6_VERSION=\(.name)"' s6-tags.json )"

cat << EOF > Dockerfile
FROM resin/rpi-raspbian

RUN apt-get update && apt-get upgrade\ 
 && apt-get install -y -q wget bash-completion nano tzdata\
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

COPY root /root/
RUN chmod 0700 /root/bin/tzconfig && echo "$TZ" > /etc/timezone; cp /usr/share/zoneinfo/$TZ /etc/localtime && exit 0 ; exit 1
CMD ["/bin/bash"]
EOF
echo "Building..."
docker build -t whw3/rpi .

cat << EOF > Dockerfile
FROM whw3/rpi
ADD s6-overlay-$S6_VERSION-armhf.tar.gz /
COPY 01-docker-entrypoint.sh /etc/cont-init.d
RUN chmod +x /etc/cont-init.d/01-docker-entrypoint.sh
ENTRYPOINT ["/init"]
EOF

[[ ! -f s6-overlay-$S6_VERSION-armhf.tar.gz ]] && \
    wget -O s6-overlay-$S6_VERSION-armhf.tar.gz https://github.com/just-containers/s6-overlay/releases/download/$S6_VERSION/s6-overlay-armhf.tar.gz

echo "Building..."
docker build -t whw3/rpi-s6 .
