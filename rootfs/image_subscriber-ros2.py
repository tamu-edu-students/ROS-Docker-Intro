#This is a minimal example, checkout full version at https://automaticaddison.com/getting-started-with-opencv-in-ros-2-foxy-fitzroy-python/ and http://wiki.ros.org/cv_bridge/Tutorials
import sys
import cv2
import rclpy
import rclpy.node
import numpy as np
from cv_bridge import CvBridge
from sensor_msgs.msg import Image

bridge = CvBridge()
def callback_Img(data):
    img = bridge.imgmsg_to_cv2(data, desired_encoding='rgb8')
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    grayImageMsg = CvBridge().cv2_to_imgmsg(gray.astype(np.uint8))
    grayImageMsg.header = data.header
    grayImageMsg.encoding = '8UC1'
    grayImgPub.publish(grayImageMsg)

rclpy.init()
colorImgSub = rclpy.node.Node('image_subscriber')
colorImgSub.create_subscription(Image, '/front_camera/image_raw', callback_Img, 10)
grayImgPub = rclpy.node.Node('image_publisher').create_publisher(Image, '/img_gray', 10)
rclpy.spin(colorImgSub)
