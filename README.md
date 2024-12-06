# Jenkins Cluster con Agentes SSH y Nginx

Este proyecto configura un cluster de Jenkins con un master, dos agentes y un servidor Nginx, todo ello usando Docker Compose.

## Componentes

- Jenkins Master con soporte para Node.js y npm
- 2 Jenkins Agents con soporte SSH
- Servidor Nginx con SSH configurado para despliegues

## Requisitos Previos

- Docker
- Docker Compose
- Git
- Bash (para ejecutar el script de configuración)

## Configuración Inicial

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd jenkins-cluster
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
   docker compose up -d
   ```

## Acceso a Jenkins

1. Acceder a Jenkins en: `http://localhost:8080`

2. Obtener la contraseña inicial de Jenkins:
   ```bash
   docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword
   ```

## Configuración de los Agentes

1. En Jenkins, ir a "Manage Jenkins" > "Manage Nodes and Clouds"
2. Añadir un nuevo nodo
3. Configurar la conexión SSH usando:
   - Host: jenkins-agent1 o jenkins-agent2
   - Usuario: jenkins
   - La clave privada ya está configurada en el contenedor

## Configuración de Nginx

- El servidor Nginx está accesible en: `http://localhost:80`
- Los despliegues se pueden realizar en `/usr/share/nginx/html`
- Hay una configuración de ejemplo para subdirectorios en `/app`

## Estructura de Directorios

```
jenkins-cluster/
├── docker-compose.yml
├── setup.sh
├── jenkins-master/
│   ├── Dockerfile
│   └── ssh/
├── jenkins-agent/
│   ├── Dockerfile
│   └── ssh/
└── nginx/
    ├── Dockerfile
    ├── conf/
    └── ssh/
```

## Notas de Seguridad

- Las claves SSH se generan localmente y no se incluyen en el repositorio
- Se recomienda cambiar las claves en entornos de producción
- Los volúmenes de Docker persisten los datos

## Mantenimiento

Para detener los servicios:
```bash
docker compose down
```

Para ver los logs:
```bash
docker compose logs -f
```