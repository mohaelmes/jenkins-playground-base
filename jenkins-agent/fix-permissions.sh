#!/bin/bash

# Esperar un momento para asegurar que el volumen está montado
sleep 5

# Asegurar permisos correctos para SSH
chown jenkins:jenkins /home/jenkins/.ssh
chmod 700 /home/jenkins/.ssh

if [ -f /home/jenkins/.ssh/authorized_keys ]; then
    chown jenkins:jenkins /home/jenkins/.ssh/authorized_keys
    chmod 600 /home/jenkins/.ssh/authorized_keys
fi

# Mostrar permisos para verificación
ls -la /home/jenkins/.ssh/

# Inicio del servicio SSH
/usr/sbin/sshd -D