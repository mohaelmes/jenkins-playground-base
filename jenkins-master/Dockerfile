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
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    npm cache clean --force

# Crear directorio .ssh y establecer permisos
RUN mkdir -p /var/jenkins_home/.ssh && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh && \
    chmod 700 /var/jenkins_home/.ssh

# Script para corregir permisos en el arranque
COPY --chown=jenkins:jenkins fix-permissions.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/fix-permissions.sh

USER jenkins

# Plugins necesarios para SSH y Pipeline
RUN jenkins-plugin-cli --plugins \
    ssh-slaves \
    ssh-agent \
    configuration-as-code \
    workflow-aggregator \
    nodejs \
    git \
    pipeline-stage-view

# Ejecutar el script de permisos antes del inicio de Jenkins
ENTRYPOINT ["/usr/local/bin/fix-permissions.sh", "/usr/local/bin/jenkins.sh"]
