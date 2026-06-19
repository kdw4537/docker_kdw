# Dockerfile

FROM ubuntu:22.04

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH="$PATH:/opt/conda/bin"

# update package
RUN apt-get update -y

# Install package dependencies
RUN apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        dbus \
        fontconfig \
        gnupg \
        libasound2 \
        libfreetype6 \
        libglib2.0-0 \
        libnss3 \
        libsqlite3-0 \
        libx11-xcb1 \
        libxcb-glx0 \
        libxcb-xkb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxi6 \
        libxml2 \
        libxrandr2 \
        libxrender1 \
        libxtst6 \
        libxkbfile1 \
        openssh-client \
        wget \
        xcb \
        xkb-data \
        build-essential

# misc tool install
RUN apt-get install -y --no-install-recommends \
        nano \
        vim \
        tmux \
        git \
        ssh \
        openssh-server \
        libxrender-dev \
        bzip2 \
        libxext6 \
        libsm6 \
        mercurial \
        subversion \
    	cmake

WORKDIR /root/workspace

# conda install
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -O ~/anaconda.sh
RUN /bin/bash ~/anaconda.sh -b -p /opt/conda
RUN rm ~/anaconda.sh
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

# update
RUN conda update -n base -c defaults conda
RUN pip install --upgrade pip

CMD [ "/bin/bash" ]

#sshd port setting
RUN apt-get update && apt-get install -y openssh-server && rm -rf /var/lib/apt/lists/*

RUN cat >> /etc/ssh/sshd_config <<'EOF'
PermitRootLogin yes
PasswordAuthentication yes
PubkeyAuthentication yes
Port 4537
EOF

RUN mkdir -p /run/sshd

EXPOSE 4537

CMD ["/usr/sbin/sshd", "-D", "-e", "-p", "4537"]
