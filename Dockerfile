ARG ROS_DISTRO

FROM ros:${ROS_DISTRO}-ros-core

RUN apt update && apt install -y --no-install-recommends \
    python3-pip \
    python3-colcon-common-extensions \
    build-essential \
    git libpcl-dev ros-${ROS_DISTRO}-pcl-conversions \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /colcon_ws/src
COPY livox_ros2_driver livox_ros2_driver 

WORKDIR /colcon_ws
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+

WORKDIR /

COPY ros_entrypoint.sh .

RUN echo 'alias build="colcon build --cmake-args --symlink-install  --event-handlers console_direct+"' >> ~/.bashrc
RUN echo 'alias run="ros2 launch livox_ros2_driver livox_lidar_launch.py"' >> ~/.bashrc
