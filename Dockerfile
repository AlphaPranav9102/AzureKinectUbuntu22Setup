# Use the official Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    udev \
    usbutils \
    libusb-1.0-0-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set up udev rules directory
RUN mkdir -p /etc/udev/rules.d/

# Add a script to initialize udev
COPY init-udev.sh /init-udev.sh
RUN chmod +x /init-udev.sh

# Start the script when the container starts
CMD ["/init-udev.sh"]

# Use the udev rule to give access to USB devices
COPY 99-usb.rules /etc/udev/rules.d/99-usb.rules

COPY setup-ubuntu.sh /home/setup-ubuntu.sh
RUN chmod +x /home/setup-ubuntu.sh
RUN ./home/setup-ubuntu.sh ${ARCH}


RUN cd home
RUN git clone https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git
RUN cd Azure-Kinect-Sensor-SDK
RUN mkdir build
WORKDIR /Azure-Kinect-Sensor-SDK/build
RUN pwd
RUN cmake .. -GNinja -DCMAKE_BUILD_TYPE=Debug
RUN ninja
