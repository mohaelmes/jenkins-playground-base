#!/bin/sh

# Asegurar permisos correctos de SSH cada vez que el contenedor arranca
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
if [ -f "/root/.ssh/authorized_keys" ]; then
    chmod 600 /root/.ssh/authorized_keys
fi

# Generar host keys si no existen
ssh-keygen -A

# Iniciar SSHD
/usr/sbin/sshd

# Iniciar Nginx en primer plano
nginx -g 'daemon off;'

