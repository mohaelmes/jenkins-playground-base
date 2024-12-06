FROM jenkins/jenkins:lts

USER root

# Instalar herramientas necesarias
RUN apt-get update && \
    apt-get install -y \
    openssh-client \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Instalar Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Crear directorio .ssh y establecer permisos
RUN mkdir -p /var/jenkins_home/.ssh && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh && \
    chmod 700 /var/jenkins_home/.ssh

USER jenkins

# Plugins necesarios para SSH y Pipeline
RUN jenkins-plugin-cli --plugins \
    ssh-slaves \
    workflow-aggregator \
    git \
    pipeline-stage-view