FROM ubuntu:14.04
 
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
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
RUN git config --global user.email "YOUREMAIL"
RUN git config --global user.name "YOURNAME"

CMD ["/usr/sbin/sshd", "-D"]

# ssh-keygen -f "/home/fabio/.ssh/known_hosts" -R "[localhost]:4022"
# setsid docker run -p 4022:22 -v /home/fabio/yocto:/home/fabio/yocto fabiomolinaris/yocto-schneider-bsc
