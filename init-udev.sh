#!/bin/bash
# Start udev
service udev start

# Keep the container running
tail -f /dev/null
