#!/bin/sh
sudo tshark -Iql \
   -i $1 \
   -T fields \
   -E separator=, \
   -E quote=d \
   -e frame.time \
   -e wlan.sa \
   -e wlan_radio.signal_dbm \
   -e frame.len \
   -e wlan.seq \
   type mgt subtype probe-req and broadcast
