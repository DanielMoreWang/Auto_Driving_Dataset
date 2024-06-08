FROM ros:melodic

# Update package index and install dependencies
RUN apt-get update && \
    apt-get install -y \
    ros-melodic-desktop-full \
    python-catkin-tools \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    cmake \
    git \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev

# Set up ROS workspace (optional)
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws/src
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_init_workspace'
WORKDIR /catkin_ws
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; catkin_make'

# Install OpenCV
WORKDIR /
RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && \
    git checkout 4.5.3 && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd / && \
    rm -rf opencv

# Source ROS and catkin workspace setup
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc && \
    echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

CMD ["/bin/bash"]