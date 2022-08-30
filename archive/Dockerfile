FROM ubuntu:22.04

ENV DEBIAN_FRONTEND "noninteractive"

RUN apt update && apt install -y openssh-server jq git unzip rsync

#install singularity 3.10.2
RUN apt install -y cryptsetup-bin runc squashfs-tools
RUN wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-jammy_amd64.deb -O singularity-ce.deb
RUN dpkg -i singularity-ce.deb

RUN useradd -m -s /bin/bash -u 1000 brainlife

#install things for brainlife
RUN git clone https://github.com/brainlife/abcd-spec /home/brainlife/abcd-spec
COPY .bashrc /home/brainlife/.bashrc
#COPY .ssh /home/brainlife/.ssh
RUN chown -R brainlife:brainlife /home/brainlife
#RUN chmod 700 /home/brainlife/.ssh

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22

RUN mkdir -p /run/sshd

##############################################################
#
# for staging
# 
RUN apt install -y autofs python3-pip python3 fuse sqlite3 unar
RUN pip install ratarmount
COPY mount.ratarmount /sbin/mount.ratarmount
COPY unmount.ratarmount /sbin/unmount.ratarmount
COPY ratar.autofs /etc/auto.master.d/ratar.autofs
COPY auto.ratar /etc/auto.ratar
RUN mkdir /ratar
#
#
#############################################################

COPY start.sh /start.sh

CMD [ "./start.sh" ]


