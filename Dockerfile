# Use ROS Noetic as the base image
FROM ros:noetic-ros-base

# Set environment variables
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    software-properties-common \
    curl \
    python3-pip \
    python3-vcstool \
    build-essential \
    cmake \
    git \
    wget \
    && locale-gen en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean

# Set locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Add ROS 2 repository key and source
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" > /etc/apt/sources.list.d/ros2.list \
    && apt-get update

# Install ROS 2 development tools and dependencies
RUN apt-get install -y --no-install-recommends \
    python3-flake8-docstrings \
    python3-pytest-cov \
    ros-dev-tools \
    && python3 -m pip install -U \
        flake8-blind-except \
        flake8-builtins \
        flake8-class-newline \
        flake8-comprehensions \
        flake8-deprecated \
        flake8-import-order \
        flake8-quotes \
        "pytest>=5.3" \
        pytest-repeat \
        pytest-rerunfailures

# Set up ROS 2 workspace
RUN mkdir -p /root/ros2_humble/src \
    && cd /root/ros2_humble \
    && vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src

# Install ROS 2 dependencies
RUN apt-get upgrade -y \
    && rosdep update \
    && rosdep install --from-paths /root/ros2_humble/src --
