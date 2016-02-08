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



#COPY SCRIPT TO RUN local xrdp server
ADD run.sh /usr/local/bin/run

#COPY CONFIG FILE
ADD xrdp.ini /etc/xrdp/

#COPY AND START XRDP LISTENING SERVICE
ADD start.sh /



#DEPS
RUN sudo apt-get -y install build-essential python-dev gfortran
RUN sudo apt-get -y install python-numpy python-scipy python-pandas

#OPENFOAM
#RUN wget https://sourceforge.net/projects/openfoamplus/files/ThirdParty-v3.0+.tgz /HOME/rloop/
#RUN wget https://sourceforge.net/projects/openfoamplus/files/OpenFOAM-v3.0+.tgz /HOME/rloop/
#RUN mkdir /HOME/rloop/OpenFOAM && tar -xzf /HOME/rloop/OpenFOAM-v3.0+.tgz -C /HOME/rloop/OpenFOAM && tar -xzf /HOME/rloop/ThirdParty-v3.0+.tgz -C /HOME/rloop/OpenFOAM
#RUN source /HOME/rloop/OpenFOAM/OpenFOAM-v3.0+/etc/bashrc
#RUN cd $WM_THIRD_PARTY_DIR && ./makeParaView4
#RUN cd $WM_PROJECT_DIR && foam
#RUN cd $WM_PROJECT_DIR && ./Allwmake

#PODUNSIM
RUN git clone https://github.com/rLoopTeam/podRunSim.git /opt/podRunSim




# for RDP and SSH
EXPOSE 3389
EXPOSE 22
CMD /start.sh
