FROM ubuntu:20.04
WORKDIR /root
ENTRYPOINT ["/bin/bash","/root/startVNC.sh"]

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl gnupg2 lsb-release sudo && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    /bin/bash -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -sc) main' | tee /etc/apt/sources.list.d/ros2.list > /dev/null" && \
    /bin/bash -c "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main' | tee /etc/apt/sources.list.d/ros.list > /dev/null" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install vim tmux git qt5-default ros-foxy-desktop ros-noetic-desktop-full tigervnc-standalone-server novnc openbox lxpanel && \
    apt-get clean && \
    echo "export DISPLAY=:1" >> .bashrc && \
    echo "source /opt/ros/foxy/setup.bash" > /root/foxy_setup.sh && \
    echo "source /opt/ros/noetic/setup.bash" > /root/noetic_setup.sh && \
    /bin/bash -c "echo -e 'password\npassword\nn' | vncpasswd" && \
    openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out novnc.pem -days 3650 -subj "/C=NA/ST=NA/L=NA/O=NA/OU=NA/CN=NA/emailAddress=NA" && \
    printf "rm -rf /tmp/.X1* \ntigervncserver :1 -xstartup /root/.xinit \n websockify --web=/usr/share/novnc/ -D --cert=novnc.pem 6080 127.0.0.1:5901 \n /bin/bash" > startVNC.sh && \
    printf "lxpanel &\n sleep 3 \n openbox-session" >.xinit && \
    chmod 777 /root/*.sh /root/.xinit
