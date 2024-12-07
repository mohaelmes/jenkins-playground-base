# Cluster Jenkins con Agentes SSH y Nginx

Este proyecto configura un cluster de Jenkins con un master, dos agentes y un servidor Nginx, todo ello usando Docker Compose.

## Componentes

- Jenkins Master con soporte para Node.js y npm
- 2 Jenkins Agents con soporte SSH, Java 17 y Node.js
- Servidor Nginx con SSH configurado para despliegues

## Requisitos Previos

- Docker
- Docker Compose
- Git
- Bash (para ejecutar el script de configuración)

## Configuración Inicial

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Cloud-DevOps-Labs/jenkins-playground-base
   cd jenkins-playground-base
   ```

2. Ejecutar el script de configuración (genera las claves SSH):
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Construir las imágenes:
   ```bash
   docker compose build
   ```

4. Iniciar los servicios:
   ```bash

   # en segundo plano
   docker compose up -d

   # En primer plano, deberemos abrir un segundo terminal para lanzar el resto de comandos
   docker compose up
   ```

Para ver los logs:
```bash
docker compose logs -f
```

## Acceso a Jenkins

1. Acceder a Jenkins en: `http://localhost:8080`
2. Obtener la contraseña inicial:
   ```bash
   docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
   ```

## Configuración de los Agentes Jenkins

### Paso 1: Preparar las Credenciales SSH
1. Ir a "Manage Jenkins" > "Manage Credentials"
2. Click en "(global)" bajo "Stores scoped to Jenkins"
3. Click en "Add Credentials"
4. Configurar la credencial de los agentes de jenkins:
   - Kind: "SSH Username with private key"
   - ID: `jenkins-agent-key`
   - Description: `Jenkins Agent SSH Key`
   - Username: `jenkins`
   - Private Key: Enter directly y pegar el contenido de `jenkins-master/ssh/jenkins_agent_key`
   - Click "Create"
5. Configurar la credencial del servidor web NGINX:
   - Kind: "SSH Username with private key"
   - ID: `webserver-key`
   - Description: `Nginx Web Server SSH Key`
   - Username: `root`
   - Private Key: Enter directly y pegar el contenido de `jenkins-master/ssh/nginx_key`
   - Click "Create"

### Paso 2: Configurar el Primer Agente (jenkins-agent1)
1. Ir a "Manage Jenkins" > "Manage Nodes and Clouds"
2. Click en "New Node"
3. Configurar:
   - Node name: `jenkins-agent1`
   - Type: "Permanent Agent"
   - Click "Create"
4. Configuración del nodo:
   - Remote root directory: `/home/jenkins/agent`
   - Labels: `jenkins-agent`
   - Launch method: "Launch agents via SSH"
   - Host: `jenkins-agent1`
   - Credentials: Seleccionar la credencial SSH creada anteriormente
   - Host Key Verification Strategy: "Non verifying Verification Strategy"
   - Click "Save"

### Paso 3: Configurar el Segundo Agente (jenkins-agent2)
- Repetir el mismo proceso que para jenkins-agent1, pero usando:
  - Node name: `jenkins-agent2`
  - Host: `jenkins-agent2`
  - El resto de la configuración igual que jenkins-agent1

### Paso 4: Configurar Pipeline desde SCM

1. En Jenkins, crear un nuevo Pipeline:
   - Click en "New Item"
   - Nombre: `playground-app`
   - Seleccionar "Pipeline"
   - Click "OK"

2. En la configuración del pipeline:
   - En la sección "Pipeline", seleccionar "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: `https://github.com/Cloud-DevOps-Labs/jenkins-playground-app.git`
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile`
   - Click "Save"

### Paso 5: Ejecutar el Pipeline

En una pestaña del navegador accedemos a localhost:80 y veremos la página por defecto de nginx.

1. Ir al proyecto `playground-app`
2. Click en "Build Now"

El pipeline:
- Clonará el repositorio
- Instalará las dependencias de Node.js
- Construirá la aplicación
- Ejecutará pruebas básicas
- Desplegará en el servidor Nginx

Una vez finalizado el despliegue podremos ver un hola mundo con la fecha actual.


## Verificación de Agentes

Para verificar que los agentes están funcionando:
1. Los agentes deberían aparecer como "online" en el dashboard de nodos
2. Puedes probar la conexión SSH manualmente:
   ```bash
   docker exec jenkins-master ssh -i /var/jenkins_home/.ssh/jenkins_agent_key jenkins@jenkins-agent1
   docker exec jenkins-master ssh -i /var/jenkins_home/.ssh/jenkins_agent_key jenkins@jenkins-agent2
   ```

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

## Mantenimiento y cierre de la práctica:

Si existen problemas para borrar las credenciales del directorio de nginx, es debido a que el directorio se ha traspasado al usuario root.
Con este comando se pueden restaurar antes de borrar:

```bash
sudo chown -R $USER:$USER $(pwd)/nginx/ssh
```

Para detener los servicios:
```bash
docker compose down
```

Para limpiar todo el entorno:
```bash
chmod +x clean.sh
./clean.sh --all
```

## Notas de Seguridad

- Las claves SSH generadas son solo para desarrollo local
- Para producción, se recomienda:
  - Generar nuevas claves con parámetros más seguros
  - Implementar una estrategia de rotación de claves
  - Usar un gestor de secretos
  - Configurar firewalls y reglas de red más restrictivas

