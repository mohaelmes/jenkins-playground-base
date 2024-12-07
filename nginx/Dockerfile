FROM nginx:1.24-alpine
#FROM public.ecr.aws/nginx/nginx:1.24-alpine

# Instalar OpenSSH
RUN apk add --no-cache openssh

# Configurar SSH
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Configurar permisos para el directorio web
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 80 22

# Script de inicio personalizado
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

