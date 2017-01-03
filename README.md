# Pulseaudio server with bluetooth (A2DP) support
Bluez5 and PulseAudio in a docker for recieve and send sound via a2dp 

This is a fork of [kvaps/pulseaudio-bluetooth](https://github.com/kvaps/docker-pulseaudio-bluetooth)
with SSP mode enabled (as some devices, particularly older ones, don't support disabling it). This
means that instead of configuring a static PIN, on first pairing you will be asked to confirm a
randomly generated PIN. This bluetooth server is configured to accept any pairing attempt automatically.

**Run command:**

```bash
docker run \
    --device /dev/bus/usb \
    --device /dev/snd \
    --name bluez \
    --net=host \
    --cap-add NET_ADMIN \
    -v /opt/bluetooth:/var/lib/bluetooth \
    -e NAME="Some-bluetooth" \
    -e DEVICE="40:EF:4C:C3:9C:CE" \
    cdauth/a2dp-server
```

**docker-compose.yml**
```yaml
pulseaudio-bluetooth:
  restart: always
  image: cdauth/a2dp-server
  devices:
    - /dev/bus/usb
    - /dev/snd
  net: host
  cap_add:
    - NET_ADMIN
  volumes:
    - /etc/localtime:/etc/locialtime:ro
    - ./bluetooth:/var/lib/bluetooth
  environment:
    - NAME=Some-bluetooth
    - DEVICE=40:EF:4C:C3:9C:CE
```

**Notes:**

- The Bluetooth device will only be available inside the container unless net=host is used (see [here](https://github.com/docker/docker/issues/16208))
- DEVICE will be the hardware address of the bluetooth card you want to use. Find out by running `hciconfig`.
- If you want to use other audio applications on your computer, you can expose port 4713 and connect to it using the PulseAudio native TCP protocol (as PulseAudio will block you audio device). The bluetooth daemon could theoretically also be connected to an existing pulseaudio server, but in my experience the sound will not play fluently.
