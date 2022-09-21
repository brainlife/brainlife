FROM ubuntu:18.04

ENV DEBIAN_FRONTEND "noninteractive"

RUN apt update && apt install -y openssh-server jq git unzip rsync curl

#install later version of node
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

#install singularity 3.10.2 (needed by resource_check)
RUN apt install -y cryptsetup-bin runc squashfs-tools
#RUN wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-jammy_amd64.deb -O singularity-ce.deb
RUN wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-focal_amd64.deb -O singularity-ce.deb
RUN dpkg -i singularity-ce.deb

#install docker
RUN curl -fsSL https://get.docker.com/ | sh

#create brainlife user
#RUN useradd -m -s /bin/bash -u 1000 brainlife
#RUN usermod -aG docker brainlife

#install things for brainlife (.ssh is injected in via docker-compose)
RUN git clone https://github.com/brainlife/abcd-spec /root/abcd-spec
COPY .bashrc /root/.bashrc
#RUN chown -R brainlife:brainlife /home/brainlife

#install noVNC
RUN git clone https://github.com/novnc/noVNC.git /usr/local/noVNC

COPY run.sh /run.sh
COPY sshd_config /etc/ssh/sshd_config

#we can't inject this in because /root/.ssh needs to be owned by root for sshd to accept it
COPY .ssh /root/.ssh
RUN chown -R root:root /root/.ssh

EXPOSE 22

RUN mkdir -p /run/sshd

#for debugging
#RUN apt install -y sudo

#for glx libs
#TODO - 470 needs to match the version of nvidia driver installed on host?
RUN apt update && apt install -y libgl1-mesa-dev mesa-utils nvidia-utils-470 libnvidia-gl-470

#COPY virtualgl_2.6_amd64.deb /tmp/virtualgl_2.6_amd64.deb
#RUN dpkg -i /tmp/virtualgl_2.6_amd64.deb

#CMD [ "/usr/sbin/sshd", "-D" ]
CMD [ "/run.sh" ]

