# 🐳 Ejecutar con Docker (Opcional)

Si deseas ejecutar este demo en Docker en el futuro, aquí están los archivos necesarios.

## Dockerfile

Crea un archivo `Dockerfile` en el directorio raíz:

```dockerfile
FROM openjdk:21-jdk-slim

# Información del mantenedor
LABEL maintainer="demo@example.com"
LABEL description="Apache Karaf Demo - Bundles OSGi"

# Variables de entorno
ENV KARAF_VERSION=4.4.5
ENV KARAF_HOME=/opt/karaf
ENV PATH=$PATH:$KARAF_HOME/bin

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y wget tar && \
    rm -rf /var/lib/apt/lists/*

# Descargar e instalar Apache Karaf
RUN wget https://dlcdn.apache.org/karaf/${KARAF_VERSION}/apache-karaf-${KARAF_VERSION}.tar.gz && \
    tar -xzf apache-karaf-${KARAF_VERSION}.tar.gz && \
    mv apache-karaf-${KARAF_VERSION} ${KARAF_HOME} && \
    rm apache-karaf-${KARAF_VERSION}.tar.gz

# Copiar bundles compilados
COPY message-service-api/target/*.jar ${KARAF_HOME}/deploy/
COPY message-service-impl/target/*.jar ${KARAF_HOME}/deploy/
COPY message-consumer/target/*.jar ${KARAF_HOME}/deploy/
COPY features/target/classes/features.xml ${KARAF_HOME}/deploy/

# Exponer puertos de Karaf
# 8101: SSH
# 1099: RMI Registry
# 44444: RMI Server
# 8181: HTTP (si se habilita)
EXPOSE 8101 1099 44444 8181

# Directorio de trabajo
WORKDIR ${KARAF_HOME}

# Comando para iniciar Karaf
CMD ["bin/karaf", "run"]
```

## docker-compose.yml

Para facilitar la ejecución, crea `docker-compose.yml`:

```yaml
version: '3.8'

services:
  karaf:
    build: .
    container_name: karaf-demo
    ports:
      - "8101:8101"  # SSH
      - "1099:1099"  # RMI Registry
      - "44444:44444"  # RMI Server
      - "8181:8181"  # HTTP (opcional)
    environment:
      - JAVA_OPTS=-Xmx512m
    volumes:
      - karaf-data:/opt/karaf/data
      - karaf-deploy:/opt/karaf/deploy
    restart: unless-stopped
    stdin_open: true
    tty: true

volumes:
  karaf-data:
  karaf-deploy:
```

## .dockerignore

Crea `.dockerignore` para optimizar la imagen:

```
.git
.idea
.mvn
target
*.iml
*.log
.DS_Store
README.md
GUIA-RAPIDA.md
RESUMEN.md
*.sh
```

## 🚀 Comandos Docker

### Compilar el Proyecto

```bash
# Compilar el proyecto con Maven
mvn clean install
```

### Construir la Imagen Docker

```bash
# Construir la imagen
docker build -t karaf-demo:1.0 .

# Ver las imágenes
docker images | grep karaf
```

### Ejecutar el Contenedor

**Opción 1: Con docker run**
```bash
docker run -it --name karaf-demo \
  -p 8101:8101 \
  -p 1099:1099 \
  -p 44444:44444 \
  karaf-demo:1.0
```

**Opción 2: Con docker-compose**
```bash
# Iniciar el servicio
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener
docker-compose down
```

### Conectarse al Contenedor

```bash
# Abrir una sesión SSH en Karaf
docker exec -it karaf-demo /opt/karaf/bin/client

# O abrir un shell en el contenedor
docker exec -it karaf-demo /bin/bash
```

### Gestión del Contenedor

```bash
# Ver contenedores corriendo
docker ps

# Ver logs
docker logs -f karaf-demo

# Detener el contenedor
docker stop karaf-demo

# Iniciar el contenedor
docker start karaf-demo

# Eliminar el contenedor
docker rm karaf-demo

# Eliminar la imagen
docker rmi karaf-demo:1.0
```

## 📦 Volúmenes Docker

Los datos persistentes se almacenan en:
- `karaf-data`: Datos de runtime de Karaf
- `karaf-deploy`: Bundles desplegados

Para limpiar volúmenes:
```bash
docker-compose down -v
```

## 🔧 Configuración Avanzada

### Agregar Features al Inicio

Modifica el Dockerfile para agregar configuración:

```dockerfile
# Agregar features al inicio
RUN echo "featuresRepositories = mvn:org.example/features/1.0-SNAPSHOT/xml/features" \
    >> ${KARAF_HOME}/etc/org.apache.karaf.features.cfg && \
    echo "featuresBoot = message-demo" \
    >> ${KARAF_HOME}/etc/org.apache.karaf.features.cfg
```

### Variables de Entorno Personalizadas

```yaml
services:
  karaf:
    environment:
      - JAVA_OPTS=-Xmx512m -Xms256m
      - KARAF_OPTS=-Dkaraf.startLocalConsole=false
```

## 🌐 Acceso Remoto

Para conectarte desde fuera del contenedor:

```bash
# SSH a Karaf (usuario: karaf, password: karaf)
ssh -p 8101 karaf@localhost
```

## 🎯 Script de Automatización

Crea `docker-run.sh`:

```bash
#!/bin/bash

echo "🐳 Construyendo imagen Docker..."
docker build -t karaf-demo:1.0 .

echo "🚀 Iniciando contenedor..."
docker run -it --rm \
  --name karaf-demo \
  -p 8101:8101 \
  -p 1099:1099 \
  -p 44444:44444 \
  karaf-demo:1.0
```

Haz el script ejecutable:
```bash
chmod +x docker-run.sh
./docker-run.sh
```

## 📝 Notas Importantes

1. **Compilación**: Siempre ejecuta `mvn clean install` antes de construir la imagen Docker
2. **Puertos**: Asegúrate de que los puertos no estén en uso
3. **Memoria**: Ajusta JAVA_OPTS según tus necesidades
4. **Persistencia**: Usa volúmenes para datos importantes
5. **Seguridad**: Cambia las credenciales por defecto de Karaf en producción

## 🐛 Solución de Problemas Docker

### Error: "Port already in use"
```bash
# Ver qué proceso usa el puerto
lsof -i :8101

# Cambiar el puerto en docker-compose.yml
ports:
  - "8102:8101"  # Usar 8102 en el host
```

### Error: "Cannot connect to Docker daemon"
```bash
# Iniciar Docker Desktop (en Mac)
open -a Docker

# O reiniciar el servicio (en Linux)
sudo systemctl restart docker
```

### Contenedor se detiene inmediatamente
```bash
# Ver logs para diagnosticar
docker logs karaf-demo

# Verificar que los bundles estén copiados
docker run --rm karaf-demo:1.0 ls -la /opt/karaf/deploy/
```

---

**Nota**: Estos archivos Docker son opcionales. El proyecto funciona perfectamente sin Docker usando Karaf nativo en Windows, Linux o macOS.

**Plataformas soportadas**: 🪟 Windows | 🐧 Linux | 🍎 macOS

