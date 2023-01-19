IMAGE_ID = i0x0i/foxy-noetic
CONTAINERID_ID = ADC_II-Dev

#Initialize container from image
init:
	sudo docker run --name $(CONTAINERID_ID) -it -v `pwd`/rootfs:/root/rootfs -p 6080:6080 -p 8888:8888 $(IMAGE_ID)
	#Use the following line for Matlab-ROS connection in Windows/Mac
	#sudo docker run --name $(CONTAINERID_ID) -it -v `pwd`/rootfs:/root/rootfs -p 6080:6080 -p 8888:8888 -p 11311:11311 -p 40000-40100:40000-40100 --sysctl net.ipv4.ip_local_port_range="40000 40100" $(IMAGE_ID)
	#Use the following line in Linux only
	#sudo docker run --name $(CONTAINERID_ID) -it -v `pwd`/rootfs:/root/rootfs --network host $(IMAGE_ID)

#Build image
build:
	sudo docker build --tag=$(IMAGE_ID) .

#Run initialized container
start:
	sudo docker start -ia $(CONTAINERID_ID)

#Stop container
stop:
	sudo docker stop $(CONTAINERID_ID)

#Attach to container
attach:
	sudo docker attach $(CONTAINERID_ID)

#Start an CLI to container
terminal:
	sudo docker exec -it $(CONTAINERID_ID) bash

#Remove container
rm:
	sudo docker rm $(CONTAINERID_ID)

#Remove image
rmi:
	sudo docker rmi $(IMAGE_ID)

#Show container status
status:
	sudo docker ps -a

#Initialize a plain ubuntu 20.04 container
plain:
	sudo docker run -it --entrypoint "/bin/bash" ubuntu:20.04
