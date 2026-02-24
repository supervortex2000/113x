#!/bin/sh

# default ab311(ad82584f) output 4ch
# run this command switch to D621(tas5782m) output 8ch

if [ -f /etc/D621 ]; then
    printf "already changed D621(tas5782m) output 8ch\n"
    exit 0
else
    touch /etc/D621
fi

if [ -f /etc/save_audioservice.conf ]; then
    rm /etc/save_audioservice.conf
fi

# Change the /etc/asound.conf
if [ -f /etc/asound_8ch.conf ]; then
    cp /etc/asound.conf /etc/asound_4ch.conf
    cp /etc/asound_8ch.conf /etc/asound.conf
fi

sync

# resart audioservice
/etc/init.d/S90audioservice restart
