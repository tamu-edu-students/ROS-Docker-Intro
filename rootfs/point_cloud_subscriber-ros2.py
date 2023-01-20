import sys
import rclpy
import rclpy.node
import numpy as np
import pcl #apt install -y python3-pcl
from sensor_msgs.msg import PointCloud2
from sensor_msgs_py import point_cloud2 #apt install -y ros-foxy-sensor-msgs-py

PointCloud2Pcd = lambda msg: np.array([p for p in point_cloud2.read_points(msg, skip_nans=True, field_names=("x", "y", "z"))]) #see msg.fields

def callback_PC(data):
    X = PointCloud2Pcd(data)
    pcd = pcl.PointCloud()
    pcd.from_array(X.astype(np.float32))
    print(pcd)
    pcl.save(pcd,'/root/rootfs/pc.pcd')
    sys.exit(0)

rclpy.init()
pcSub = rclpy.node.Node('pointcloud_subscriber')
pcSub.create_subscription(PointCloud2, '/lidar_left/velodyne_points', callback_PC, 10)
rclpy.spin(pcSub)
