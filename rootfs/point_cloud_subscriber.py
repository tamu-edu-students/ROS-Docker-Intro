import sys
import rospy
import numpy as np
import pcl #apt install -y python3-pcl
from sensor_msgs.msg import PointCloud2
import sensor_msgs.point_cloud2 as point_cloud2

PointCloud2Pcd = lambda msg: np.array([p for p in point_cloud2.read_points(msg, skip_nans=True, field_names=("x", "y", "z"))]) #see msg.fields

def callback_PC(data):
    X = PointCloud2Pcd(data)
    pcd = pcl.PointCloud()
    pcd.from_array(X.astype(np.float32))
    print(pcd)
    pcl.save(pcd,'/root/rootfs/pc.pcd')
    rospy.signal_shutdown("")
    sys.exit(0)

rospy.init_node('pc_record_node')
rospy.Subscriber("/lidar_left/velodyne_points", PointCloud2, callback_PC)
rospy.spin()
