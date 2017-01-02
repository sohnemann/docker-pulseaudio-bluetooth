#!/bin/bash
rm -f /run/dbus/pid
rm -rf /tmp/pulse-*
dbus-daemon --system --fork
eval "$(dbus-launch)"
export DBUS_SESSION_BUS_ADDRESS
export DBUS_SESSION_BUS_PID
pulseaudio --log-level=1 &
/usr/lib/bluetooth/bluetoothd --plugin=a2dp -n &
avahi-daemon -D
. /bin/simple-bluetooth-agent.sh
