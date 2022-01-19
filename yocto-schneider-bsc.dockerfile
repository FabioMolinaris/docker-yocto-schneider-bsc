FROM ubuntu:14.04
 
RUN apt-get update -y && apt-get upgrade -y

# yocto
RUN apt-get update
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect
RUN apt-get install -y libsdl1.2-dev xterm
RUN apt-get install -y autoconf automake libtool libglib2.0-dev libarchive-dev

# 96Boards specific
RUN apt-get install -y git whiptail curl
RUN apt-get install -y android-tools-fsutils

# tools
RUN apt-get install -y vim
RUN apt-get install -y sudo
RUN apt-get install -y ftp
RUN apt-get install -y subversion

# jenkins
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN apt-get install -y openjdk-7-jdk

# mkfs.fat & sgdisk
RUN apt-get install -y dosfstools gdisk

# chroot
RUN apt-get install -y qemu qemu-user-static binfmt-support debootstrap

RUN apt-get install -y openssh-server
# RUN mkdir /var/run/sshd
RUN echo 'root:my_strong_password' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
 
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
 
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
 
EXPOSE 22

# cannot use the BSP as root
RUN useradd -ms /bin/bash fabio 
RUN usermod -aG sudo fabio
RUN echo 'fabio:fabio' | chpasswd

# Running command for Advantech Yocto BSP for Schneider BSC
RUN apt-get install -y gawk wget git git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping phablet-tools

# git config
RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"
RUN git config --global color.ui "auto"

# repo
RUN mkdir -p ${HOME}/bin
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
RUN chmod a+x ${HOME}/bin/repo
ENV PATH="/home/adv/bin:${PATH}"

# locale
RUN sudo locale-gen en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG="en_US.UTF-8"

CMD ["/usr/sbin/sshd", "-D"]

# ssh-keygen -f "/home/fabio/.ssh/known_hosts" -R "[localhost]:4022"
# setsid docker run -p 4022:22 -v /home/fabio/yocto:/home/fabio/yocto fabiomolinaris/yocto-schneider-bsc
