# Base Image: Ubuntu
FROM ubuntu:latest

CMD ["--cpus", "24"]
CMD ["--memory", "64g"]
CMD ["--oom-kill-disable"]

# Working Directory
WORKDIR /root

# Maintainer
MAINTAINER SatoruGojo2k23 <satorugojo4200@gmail.com>

# Delete the profile files (we'll copy our own in the next step)
RUN \
rm -f \
    /etc/profile \
    ~/.profile \
    ~/.bashrc

# Copy the Proprietary Files
COPY ./proprietary / 

# apt update
RUN apt update

# Install sudo
RUN apt install apt-utils sudo -y
     
# tzdata
ENV TZ Asia/Dhaka


RUN \
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata \
&& ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
&& apt-get install -y tzdata \
&& dpkg-reconfigure --frontend noninteractive tzdata

# Install git and ssh
RUN sudo apt install git ssh -y
RUN sudo apt install repo -y

# Configure git
ENV GIT_USERNAME SatoruGojo2k23
ENV GIT_EMAIL satorugojo4200@gmail.com
RUN \
    git config --global user.name $GIT_USERNAME \
&&  git config --global user.email $GIT_EMAIL

# Update Packages
RUN \
sudo apt update

# Upgrade Packages
RUN \
sudo apt upgrade -y

# Autoremove Unwanted Packages
RUN \
sudo apt autoremove -y

# Install Packages
RUN \
sudo apt install \
    curl wget aria2 tmate python2 python3 silversearch* \
    iputils-ping iproute2 \
    nano rsync git-lfs rclone tmux screen openssh-server bc bison build-essential ccache curl flex g++-multilib gcc-multilib git git-lfs gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5 libncurses5-dev libsdl1.2-dev libssl-dev libwxgtk3.0-gtk3-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev \
    python3-pip adb fastboot jq npm neofetch mlocate \
    zip unzip tar ccache \
    cpio lzma \
    -y

# Filesystems
RUN \
sudo apt install \
    erofs-utils \
    -y

RUN \
sudo pip install \
    twrpdtgen

# Install schedtool and Java
RUN \
    sudo apt install \
        schedtool openjdk-8-jdk \
    -y

# Setup Android Build Environment
RUN \
git clone https://github.com/akhilnarang/scripts.git /tmp/scripts \
&& sudo bash /tmp/scripts/setup/android_build_env.sh \
&& rm -rf /tmp/scripts

# Use python2 as the Default python
RUN \
sudo ln -sf /usr/bin/python2 /usr/bin/python

RUN \
sudo pip install ninja

# Run bash
CMD ["bash"]
