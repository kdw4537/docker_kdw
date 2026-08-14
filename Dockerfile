# Dockerfile
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG PORT

RUN test -n "$USERNAME" && test -n "$USER_UID" && test -n "$USER_GID"

# update package
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends sudo

# adduser
RUN if ! getent group ${USER_GID} > /dev/null; then \
        groupadd -g ${USER_GID} ${USERNAME}; \
    fi && \
    if ! id -u ${USERNAME} > /dev/null 2>&1; then \
        useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME}; \
    fi && \
    usermod -aG sudo ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

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
        curl \
        ca-certificates \
        xcb \
        xkb-data \
        build-essential

# misc tool install
RUN apt-get install -y --no-install-recommends \
        nano \
        vim \
        tmux \
        git \
        libxrender-dev \
        bzip2 \
        libxext6 \
        libsm6 \
        mercurial \
        subversion \
    	cmake

## conda install
#RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -O ~/anaconda.sh
#RUN /bin/bash ~/anaconda.sh -b -p /opt/conda
#RUN rm ~/anaconda.sh
#RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
#RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
#RUN conda update -n base -c defaults conda

# Miniconda latest install
#RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
#    /bin/bash /tmp/miniconda.sh -b -p /opt/conda && \
#    rm /tmp/miniconda.sh && \
#    /opt/conda/bin/conda clean -afy
#
#ENV PATH="/opt/conda/bin:${PATH}"
#
#RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
#    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/bash.bashrc

# update
RUN pip install --upgrade pip

# prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Codex CLI
# --------------------------------------------------
USER ${USERNAME}
WORKDIR /home/${USERNAME}

RUN curl -fsSL https://chatgpt.com/codex/install.sh | sh

# --------------------------------------------------
# Claude Code
# --------------------------------------------------
RUN curl -fsSL https://claude.ai/install.sh | bash

USER root
WORKDIR /home/${USERNAME}/workspace

#sshd port setting
RUN apt-get update && apt-get install -y --no-install-recommends net-tools rsync ssh openssh-server && rm -rf /var/lib/apt/lists/*

RUN cat >> /etc/ssh/sshd_config <<'EOF'
PermitRootLogin yes
PasswordAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
Port ${PORT}
EOF

RUN mkdir -p /run/sshd

EXPOSE ${PORT}

EOF

CMD ["/usr/sbin/sshd", "-D", "-e"]
