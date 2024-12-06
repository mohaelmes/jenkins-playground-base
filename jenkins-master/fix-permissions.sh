#!/bin/bash

# Esperar un momento para asegurar que el volumen está montado
sleep 5

# Asegurar que el directorio .ssh existe
mkdir -p /var/jenkins_home/.ssh
chown jenkins:jenkins /var/jenkins_home/.ssh
chmod 700 /var/jenkins_home/.ssh

# Verificar y establecer permisos solo si los archivos existen
for file in jenkins_agent_key nginx_key config; do
    if [ -f "/var/jenkins_home/.ssh/$file" ]; then
        chmod 600 "/var/jenkins_home/.ssh/$file"
    fi
done

for file in jenkins_agent_key.pub nginx_key.pub; do
    if [ -f "/var/jenkins_home/.ssh/$file" ]; then
        chmod 644 "/var/jenkins_home/.ssh/$file"
    fi
done

# Cambiar propietario de todos los archivos en .ssh si existen
if [ -d "/var/jenkins_home/.ssh" ]; then
    chown -R jenkins:jenkins /var/jenkins_home/.ssh/*
fi

# Ejecutar el comando original de Jenkins
exec "$@"