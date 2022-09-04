# An Introduction On using ROS/Docker

## Basic Requirement
Any machine with [Docker](https://docs.docker.com/get-docker/) installed. Learn more about Docker and container [here](https://www.docker.com/resources/what-container/).


## Setup ROS in Docker
For x64 machine, run ```make init``` will download and initalize the container with [ROS Foxy/Noetic](https://docs.ros.org/).

If you don't have ```make```, just copy and run [line 6 in the Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/Makefile#L6).

For arm64 machine, run ```make build``` before running ```make init```.

A CLI to the container will be granted after this step.

For GUI access, use your broswer to visit [this page](http://127.0.0.1:6080/vnc.html).

Other operations on the container can be found in the [Makefile](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/Makefile).

[demo-step1.webm](https://user-images.githubusercontent.com/7988312/188325273-39f55d31-c1f3-4ebc-8151-3e32039b1098.webm)


## Play a ROS1 Bag File
1. Download a bag file from [here](https://drive.google.com/file/d/1wd52kaQGrDC4oLVAq-fCSeIch1_wm808/view?usp=sharing) and move it to the shared folder *rootfs/*. Learn more about ROS bag [here](http://wiki.ros.org/Bags).

2. In the container CLI
    - run ```source ./noetic_setup.sh``` to initiate ROS 1 environment
    - run ```roscore &``` and ```rviz &``` to start [RViz](http://wiki.ros.org/rviz)
    - run ```rosbag play -r 10 --loop rootfs/16-mcity1.bag``` to play the downloaded bag file

3. In the container GUI
    - open config file ```demo.rviz``` in folder */root/rootfs/* from RViz, it should show the images and point clouds now

[demo-step2.webm](https://user-images.githubusercontent.com/7988312/188325293-436ab815-c94a-4973-bad0-0e6c848a67c9.webm)


## Try Some ROS1 Nodes
1. Image ROS Node ([view code](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/rootfs/image_subscriber.py))

    In the container GUI, open mutiple terminals
    - run ```source ./noetic_setup.sh; (roscore &); rosbag play -r 10 --loop rootfs/16-mcity1.bag``` in terminal 1
    - run ```source ./noetic_setup.sh; (rqt_image_view &); python3 /root/rootfs/image_subscriber.py``` in terminal 2
    - select image topic ```/front_camera/image_raw``` and ```/img_gray``` to see the original image and the gray image produced by the ROS node.

    [demo-step3_1.webm](https://user-images.githubusercontent.com/7988312/188329604-5234085e-3450-4567-9694-aba2ae52efd4.webm)

2. PointCloud ROS Node ([view code](https://github.com/tamu-edu-students/ROS-Docker-Intro/blob/main/rootfs/point_cloud_subscriber.py))

    In the container GUI,
    - run ```apt install -y python3-pcl; python3 /root/rootfs/point_cloud_subscriber.py``` in terminal 2
    - pointcloud file will be exported to shared folder *rootfs/* by the ROS node

    In the host machine, use [CouldCompare](https://www.danielgm.net/cc/) or [Matlab](https://www.mathworks.com/help/vision/ref/pcread.html) to view the exported pointcloud file
    
    [demo-step3_2.webm](https://user-images.githubusercontent.com/7988312/188329621-7769981c-05a8-45b2-835f-7a9e910b3f72.webm)


## Create Your ROS Package and Docker Image
1. Create a workspace with ```mkdir -p /root/rootfs/demo_workspace/src``` and initialize it following the tutorials [[ROS 1](http://wiki.ros.org/catkin/Tutorials/create_a_workspace), [ROS 2](https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries/Creating-A-Workspace/Creating-A-Workspace.html)]

2. Follow the rest of tutorials to create your ROS package and ROS node [[ROS 1](http://wiki.ros.org/ROS/Tutorials), [ROS 2](https://docs.ros.org/en/foxy/Tutorials/Beginner-Client-Libraries.html)]

3. Add the dependencies of your package to ```Dockerfile.template``` and build your image with ```docker build -f Dockerfile.template --tag=IMAGE_NAME```


## Trouble shoot
