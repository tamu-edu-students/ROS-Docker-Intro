# An Introduction On using ROS/Docker

## Basic Requirement
Any machine with [Docker](https://docs.docker.com/get-docker/) installed. Learn more about Docker and container [here](https://www.docker.com/resources/what-container/).


## Setup ROS in Docker
For x64 machine, run ```make init``` will download and initalize the container with [ROS Foxy/Noetic](https://docs.ros.org/).

If you don't have ```make```, just copy and run [line 6 in the Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/Makefile#L6).

For arm64 machine, run ```make build-arm64``` before running ```make init```.

A CLI to the container will be granted after this step.

For GUI access, use a [VNC viewer](https://github.com/TigerVNC/tigervnc/releases/tag/v1.12.0) to connect to 127.0.0.1:5901.

Other operations on the container can be found in the [Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/Makefile).

## Trouble shoot

