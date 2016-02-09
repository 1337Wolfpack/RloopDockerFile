FROM ubuntu:14.04

MAINTAINER Julien Le Bourg

#INSTALL apt-add-repository
RUN apt-get update
RUN sudo apt-get -y install software-properties-common

#SSH
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile



#Python and pip
RUN apt-get install -y python
RUN sudo apt-get install -y python-pip

#XRDP
RUN apt-get install -yq xterm xrdp apt-utils sudo

#ADD rloop User
RUN sudo adduser --disabled-password --gecos "" rloop
RUN sudo adduser rloop sudo
RUN sudo adduser rloop users
RUN sudo echo "rloop:rloop" | chpasswd

#GIT
RUN sudo apt-get install git -y

#DESTKOP ENVIRONMENT (MATE)
RUN sudo apt-add-repository ppa:ubuntu-mate-dev/ppa
RUN sudo apt-add-repository ppa:ubuntu-mate-dev/trusty-mate
RUN sudo apt-get update && sudo apt-get upgrade -y
RUN sudo apt-get install -y --no-install-recommends ubuntu-mate-core ubuntu-mate-desktop


#BACKUP SYSTEM (needs to use some volume mounted at /Backups)
RUN sudo apt-get install -y rsnapshot
ADD rsnapshot/rsnapshot.conf /etc/rsnapshot.conf
ADD rsnapshot/service/rsnapshot /etc/cron.d/rsnapshot


#COPY CONFIG FILE
ADD xrdp.ini /etc/xrdp/

#DEPS
RUN sudo apt-get -y install build-essential python-dev gfortran
RUN sudo apt-get -y install python-numpy python-scipy python-pandas

#PODUNSIM
RUN git clone https://github.com/rLoopTeam/podRunSim.git /home/rloop/podRunSim


# OpenFOAM

# Downloading source code
RUN mkdir /opt/OpenFOAM
WORKDIR /opt/OpenFOAM

RUN wget http://downloads.sourceforge.net/foam/OpenFOAM-3.0.1.tgz?use_mirror=mesh
RUN mv OpenFOAM-3.0.1.tgz?use_mirror=mesh OpenFOAM-3.0.1.tgz
RUN tar xzf OpenFOAM-3.0.1.tgz
RUN rm OpenFOAM-3.0.1.tgz

# Third-Party
RUN wget http://downloads.sourceforge.net/foam/ThirdParty-3.0.1.tgz?use_mirror=mesh
RUN mv ThirdParty-3.0.1.tgz?use_mirror=mesh ThirdParty-3.0.1.tgz
RUN tar xzf ThirdParty-3.0.1.tgz
RUN rm ThirdParty-3.0.1.tgz 

# Dependencies

RUN apt-get install -y flex bison gnuplot zlib1g-dev libopenmpi-dev openmpi-bin qt4-dev-tools libqt4-dev libqt4-opengl-dev freeglut3-dev libqtwebkit-dev
RUN apt-get install -y libreadline-dev libglfw2 libglfw-dev freeglut3-dev libglew-dev libcheese7 libcheese-gtk23 libclutter-gst-2.0-0 libcogl15 libclutter-gtk-1.0-0 libclutter-1.0-0 csh libptscotch-5.1
RUN apt-get install -y libncurses-dev libxt-dev libscotch-dev libcgal-dev binutils-dev


RUN sudo add-apt-repository http://www.openfoam.org/download/ubuntu
RUN apt-get update
#RUN apt-get install -y openfoam30
#RUN apt-get install -y paraviewopenfoam44
RUN apt-get install qt4-dev-tools 

RUN wget http://www.openfoam.org/download/ubuntu/dists/trusty/main/binary-amd64/openfoam30_1-1_amd64.deb

RUN wget http://www.openfoam.org/download/ubuntu/dists/trusty/main/binary-amd64/paraviewopenfoam44_0-1_amd64.deb

RUN dpkg -i openfoam30_1-1_amd64.deb

RUN dpkg -i paraviewopenfoam44_0-1_amd64.deb 

# Setting environment variable
ENV FOAM_INST_DIR /opt/OpenFOAM

#Custom build script
#ADD OpenFOAM/install.sh /opt/OpenFOAM/install.sh
#RUN /opt/OpenFOAM/install.sh

# gmsh installation

RUN mkdir ~/gMsh
WORKDIR ~/gMsh
RUN wget http://geuz.org/gmsh/bin/Linux/gmsh-2.9.2-Linux64.tgz
RUN tar -xzvf gmsh-2.9.2-Linux64.tgz
RUN rm gmsh-2.9.2-Linux64.tgz
RUN ln -s ~/gMsh/gmsh-2.9.2-Linux/bin/gmsh /usr/bin/gmsh

RUN apt-get install virtualgl

WORKDIR /opt
RUN mkdir xrdpx11
WORKDIR /opt/xrdpx11
RUN git clone https://github.com/scarygliders/X11RDP-o-Matic.git .
RUN X11rdp-o-matic.sh --justdoit

# for RDP and SSH
EXPOSE 3389
EXPOSE 22

#COPY AND START XRDP LISTENING SERVICE
ADD start.sh /
CMD /start.sh
