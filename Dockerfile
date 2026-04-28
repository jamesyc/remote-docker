FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    htop \
    iproute2 \
    less \
    locales \
    nano \
    openssh-server \
    python3 \
    python3-pip \
    python3-venv \
    rsync \
    sudo \
    tmux \
    vim \
    wget \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://tailscale.com/install.sh | sh

RUN locale-gen en_US.UTF-8 \
 && mkdir -p /run/sshd /root/.ssh /workspace /data \
 && chmod 700 /root/.ssh

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /workspace

EXPOSE 22

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

