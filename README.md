# An Introduction On using ROS/Docker

## Basic Requirement
Any machine with [Docker](https://docs.docker.com/get-docker/) installed. Learn more about Docker and container [here](https://www.docker.com/resources/what-container/).


## Setup ROS in Docker ([demo video](https://user-images.githubusercontent.com/7988312/188325273-39f55d31-c1f3-4ebc-8151-3e32039b1098.webm))
Open a Terminal/Powershell

For x64 machine, run ```make init``` will download and initalize the container with [ROS Foxy/Noetic](https://docs.ros.org/).

If you don't have ```make```, just copy and run [line 6 in the Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/Makefile#L6).

For arm64 machine, run ```make build``` before running ```make init```.

A CLI to the container will be granted after this step.

For GUI access, use your broswer to visit [this page](http://127.0.0.1:6080/vnc.html) with [*password*].

Other operations on the container can be found in the [Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/Makefile).


## Play a ROS1 Bag File ([demo video](https://user-images.githubusercontent.com/7988312/214894356-eb3c2a65-6a5b-4ae3-8e93-2ac607f19671.webm))
1. Download a bag file from [here](https://drive.google.com/file/d/1wd52kaQGrDC4oLVAq-fCSeIch1_wm808/view?usp=sharing) and move it to the shared folder *rootfs/*. Learn more about ROS bag [here](http://wiki.ros.org/Bags).

2. In the container CLI
    - run ```source /root/rootfs/foxy_setup.sh``` to initiate ROS 2 environment
    - run ```rviz2 &``` to start [RViz](http://wiki.ros.org/rviz)
    - run ```ros2 bag play -r 10 -s rosbag_v2 --loop rootfs/16-mcity1.bag``` to play the downloaded bag file

3. In the container GUI
    - open config file ```demo-ROS2.rviz``` in folder */root/rootfs/* from RViz, it should show the images and point clouds now


## Try Some ROS2 Nodes
1. Image ROS Node ([view code](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/rootfs/image_subscriber-ros2.py) | [demo video](https://user-images.githubusercontent.com/7988312/188329604-5234085e-3450-4567-9694-aba2ae52efd4.webm))

    In the container GUI, open mutiple terminals
    - run ```source /root/rootfs/foxy_setup.sh; ros2 bag play -r 10 -s rosbag_v2 --loop rootfs/16-mcity1.bag``` in terminal 1
    - run ```source /root/rootfs/foxy_setup.sh; (ros2 run rqt_image_view rqt_image_view &); python3 /root/rootfs/image_subscriber-ros2.py``` in terminal 2
    - select image topic ```/front_camera/image_raw``` and ```/img_gray``` to see the original image and the gray image produced by the ROS node.

2. PointCloud ROS Node ([view code](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/rootfs/point_cloud_subscriber-ros2.py) | [demo video](https://user-images.githubusercontent.com/7988312/188329621-7769981c-05a8-45b2-835f-7a9e910b3f72.webm))

    In the container GUI,
    - run ```apt install -y python3-pcl ros-foxy-sensor-msgs-py; python3 /root/rootfs/point_cloud_subscriber-ros2.py``` in terminal 2
    - pointcloud file will be exported to shared folder *rootfs/* by the ROS node

    In the host machine, use [CouldCompare](https://www.danielgm.net/cc/) or [Matlab](https://www.mathworks.com/help/vision/ref/pcread.html) to view the exported pointcloud file

2. GPS ROS Node ([view code](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/rootfs/gps_subscriber-ros2.py))

    In the container GUI,
    - run ```pip install utm; python3 /root/rootfs/gps_subscriber-ros2.py``` in terminal 2
    - the ROS node will print the gps coordinates


## Create Your ROS Package and Docker Image ([ROS1](https://clearpathrobotics.com/ros-robot-operating-system-cheat-sheet/) | [ROS2](https://www.theconstructsim.com/wp-content/uploads/2021/10/ROS2-Command-Cheat-Sheets-updated.pdf) | [Docker Cheat Sheets](https://dockerlux.github.io/pdf/cheat-sheet-v2.pdf))

1. Create a workspace with ```mkdir -p /root/rootfs/demo_workspace/src``` and initialize it following the tutorials [[ROS 1](http://wiki.ros.org/catkin/Tutorials/create_a_workspace), [ROS 2](https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html)]

2. Follow the rest of tutorials to create your ROS package and ROS node [[ROS 1](http://wiki.ros.org/ROS/Tutorials), [ROS 2](https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries.html)]

3. Add the dependencies of your package to ```Dockerfile.template``` and build your image with ```docker build -f Dockerfile.template --tag=IMAGE_NAME```


## Trouble shoot

1. No topic showes up in ```rqt_image_view```
    - Try to run ```ros2 topic list``` before running ```rqt_image_view```
2. Docker does not work on my computer
    - You can use a VM/WSL as an alternative, follow the setup in [the Dockerfile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/Dockerfile) (install fresh Ubuntu 20.04 and all the dependencies)
3. ```make init``` or [line 6 in the Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/ROS2/Makefile#L6) does not work
    - Replace ``` `pwd` ``` with the absolute path of this tutorial folder
4. ```ros2: command not found``` or ```No module named 'rclpy'```
    - run ```source /root/rootfs/foxy_setup.sh``` in your terminal and try again
5. Get ```Aborted (core dumped)``` when running ```rviz2```
    - Restart your docker (exit container then ```make start```) and try again, DO NOT source ```noetic_setup.sh``` after sourcing ```foxy_setup.sh```
6. How to skip the ```source /root/rootfs/foxy_setup.sh``` step
    - Add ```source /root/rootfs/foxy_setup.sh``` to the end of ```/root/.bashrc```, restart the terminal
7. Copy and paste to/from noVNC is annoying
    - Add ```-localhost no``` the end of the second line in ```/root/startVNC.sh```, restart docker and use ```ifconfig``` to show DOCKER_IP, then connect to DOCKER_IP:5901 with an [VNC client](https://www.realvnc.com/en/connect/download/viewer/) (CAUTION! This will expose your docker VNC to public IP instead of localhost)

