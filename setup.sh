#!/bin/bash

# Crear directorios necesarios
mkdir -p jenkins-master/ssh
mkdir -p jenkins-agent/ssh
mkdir -p nginx/ssh

# Limpiar directorios SSH si existen archivos
rm -f jenkins-master/ssh/*
rm -f jenkins-agent/ssh/*
rm -f nginx/ssh/*

# Generar claves SSH para Jenkins (master y agentes)
ssh-keygen -m PEM -t rsa -b 4096 -f jenkins-master/ssh/jenkins_agent_key -N ""
cp jenkins-master/ssh/jenkins_agent_key.pub jenkins-agent/ssh/authorized_keys

# Generar claves SSH para Nginx
ssh-keygen -m PEM -t rsa -b 4096 -f jenkins-master/ssh/nginx_key -N ""
cp jenkins-master/ssh/nginx_key.pub nginx/ssh/authorized_keys

# Crear archivo de configuración SSH para Jenkins master
cat > jenkins-master/ssh/config << EOL
Host jenkins-agent1
    HostName jenkins-agent1
    User jenkins
    IdentityFile /var/jenkins_home/.ssh/jenkins_agent_key
    StrictHostKeyChecking no

Host jenkins-agent2
    HostName jenkins-agent2
    User jenkins
    IdentityFile /var/jenkins_home/.ssh/jenkins_agent_key
    StrictHostKeyChecking no

Host nginx-web
    HostName nginx-web
    User root
    IdentityFile /var/jenkins_home/.ssh/nginx_key
    StrictHostKeyChecking no
EOL

# Establecer permisos restrictivos
chmod 700 jenkins-master/ssh jenkins-agent/ssh nginx/ssh
chmod 600 jenkins-master/ssh/jenkins_agent_key jenkins-master/ssh/nginx_key jenkins-master/ssh/config
chmod 644 jenkins-master/ssh/jenkins_agent_key.pub jenkins-master/ssh/nginx_key.pub jenkins-agent/ssh/authorized_keys nginx/ssh/authorized_keys

echo "Setup completed. Verificando permisos:"
ls -la jenkins-master/ssh/
echo "Permisos del agente:"
ls -la jenkins-agent/ssh/
