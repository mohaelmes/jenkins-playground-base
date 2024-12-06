FROM ubuntu:22.04@sha256:6042500cf4b44023ea1894effe7890666b0c5c7871ed83a97c36c76ae560bb9b

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas necesarias
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    openjdk-17-jdk \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm cache clean --force

# Crear usuario jenkins
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins/.ssh

# Configurar SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config

# Script para establecer permisos correctos
COPY fix-permissions.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/fix-permissions.sh

EXPOSE 22

CMD ["/usr/local/bin/fix-permissions.sh"]
