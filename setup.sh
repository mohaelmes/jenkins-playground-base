#!/bin/bash

# Crear directorios necesarios
mkdir -p jenkins-master/ssh
mkdir -p jenkins-agent/ssh
mkdir -p nginx/ssh

# Generar claves SSH para Jenkins (master y agentes)
ssh-keygen -t rsa -b 4096 -f jenkins-master/ssh/jenkins_agent_key -N ""
cp jenkins-master/ssh/jenkins_agent_key.pub jenkins-agent/ssh/authorized_keys

# Generar claves SSH para Nginx
ssh-keygen -t rsa -b 4096 -f jenkins-master/ssh/nginx_key -N ""
cp jenkins-master/ssh/nginx_key.pub nginx/ssh/authorized_keys

# Establecer permisos correctos
chmod 600 jenkins-master/ssh/jenkins_agent_key
chmod 600 jenkins-master/ssh/nginx_key
chmod 644 jenkins-agent/ssh/authorized_keys
chmod 644 nginx/ssh/authorized_keys

# Crear archivo de configuración SSH para Jenkins master
cat > jenkins-master/ssh/config << EOL
Host jenkins-agent1
    HostName jenkins-agent1
    User jenkins
    IdentityFile ~/.ssh/jenkins_agent_key
    StrictHostKeyChecking no

Host jenkins-agent2
    HostName jenkins-agent2
    User jenkins
    IdentityFile ~/.ssh/jenkins_agent_key
    StrictHostKeyChecking no

Host nginx-web
    HostName nginx-web
    User root
    IdentityFile ~/.ssh/nginx_key
    StrictHostKeyChecking no
EOL

chmod 600 jenkins-master/ssh/config