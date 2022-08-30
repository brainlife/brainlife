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
RUN chown -R brainlife:brainlife /home/brainlife

COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22

RUN mkdir -p /run/sshd

CMD [ "/usr/sbin/sshd", "-D" ]


