IMAGE_ID = i0x0i/foxy-noetic
CONTAINERID_ID = ADC_II-Dev

#Initialize container from image
init:
	sudo docker run --name $(CONTAINERID_ID) -it -v `pwd`/rootfs:/root/rootfs --network host $(IMAGE_ID)

#Build x64 image
build:
	sudo docker build --tag=$(IMAGE_ID) .

#Build arm64 image
build-arm64:
	sudo docker build -f Dockerfile.arm64 --tag=$(IMAGE_ID):arm64 .

#Run initialized container
run:
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
