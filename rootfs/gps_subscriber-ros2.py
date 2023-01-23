import sys
import utm #pip install utm #Convert NATO UTM to LL https://www.dmap.co.uk/utmworld.htm
import rclpy
import rclpy.node
import numpy as np
from nav_msgs.msg import Odometry

utm2ll = lambda x, y: utm.to_latlon(y, x,zone_number=17,zone_letter='T') #Mcity is 17T, Rellis is 14R
callback_GPS = lambda data: print(utm2ll(data.pose.pose.position.x, data.pose.pose.position.y))

rclpy.init()
gpsSub = rclpy.node.Node('gps_subscriber')
gpsSub.create_subscription(Odometry, '/navsat/odom', callback_GPS, 10)
rclpy.spin(gpsSub)
