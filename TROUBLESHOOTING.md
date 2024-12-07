## Solución de Problemas

### Problemas de Permisos SSH
Verificar permisos en los agentes:
```bash
docker exec jenkins-agent1 ls -la /home/jenkins/.ssh
docker exec jenkins-agent1 ls -la /home/jenkins/agent
```

Los permisos correctos deben ser:
- Directorio .ssh: 700
- authorized_keys: 644
- Directorio agent: 755

### Problemas de Conexión
Verificar la conectividad SSH:
```bash
docker exec jenkins-master ssh -vvv -i /var/jenkins_home/.ssh/jenkins_agent_key jenkins@jenkins-agent1
```

### Verificar Versiones de Java
```bash
docker exec jenkins-agent1 java -version
docker exec jenkins-agent2 java -version
```
Ambos agentes deben mostrar OpenJDK 17.

### Problemas de Compilación

Si hay problemas al compilar con Node.js:
1. Verificar que Node.js y npm están instalados en los agentes:
   ```bash
   docker exec jenkins-agent1 node --version
   docker exec jenkins-agent1 npm --version
   ```
2. Verificar que el plugin de Node.js está instalado en Jenkins y configurado correctamente

### Problemas con el Servidor Nginx

1. Verificar que Nginx está corriendo:
   ```bash
   docker exec nginx-web nginx -t
   docker exec nginx-web service nginx status
   ```
2. Verificar los permisos de las claves SSH para el despliegue:
   ```bash
   docker exec nginx-web ls -la /root/.ssh
   ```

   
