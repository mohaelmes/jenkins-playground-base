FROM ubuntu:20.04

# Evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas necesarias
RUN apt-get update && \
    apt-get install -y \
    openssh-server \
    openjdk-11-jdk \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Crear usuario jenkins
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chmod 700 /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins/.ssh

# Configurar SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]