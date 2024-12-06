FROM nginx:1.24-alpine
#FROM public.ecr.aws/nginx/nginx:1.24-alpine

# Instalar OpenSSH
RUN apk add --no-cache openssh

# Configurar SSH
RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Configurar permisos para el directorio web
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 80 22

# Iniciar SSH y Nginx
CMD sh -c "ssh-keygen -A && /usr/sbin/sshd && nginx -g 'daemon off;'"
