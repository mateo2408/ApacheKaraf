# Guía de Inicio Rápido - Apache Karaf Demo

## ⚡ Pasos Rápidos para Ejecutar el Demo

### 1️⃣ Instalar Apache Karaf

#### 🍎 **macOS**

**Opción A: Con Homebrew (Recomendado)**
```bash
brew install karaf
```

**Opción B: Instalación Manual**
```bash
cd ~/Downloads
curl -O https://dlcdn.apache.org/karaf/4.4.5/apache-karaf-4.4.5.tar.gz
tar -xzf apache-karaf-4.4.5.tar.gz
sudo mv apache-karaf-4.4.5 /opt/karaf
export PATH=$PATH:/opt/karaf/bin
```

**Opción C: Con el script incluido**
```bash
./install-karaf.sh
```

#### 🐧 **Linux**

**Opción A: Instalación Manual**
```bash
cd ~/Downloads
wget https://dlcdn.apache.org/karaf/4.4.5/apache-karaf-4.4.5.tar.gz
tar -xzf apache-karaf-4.4.5.tar.gz
sudo mv apache-karaf-4.4.5 /opt/karaf
sudo chown -R $USER:$USER /opt/karaf
export PATH=$PATH:/opt/karaf/bin
echo 'export PATH=$PATH:/opt/karaf/bin' >> ~/.bashrc
```

**Opción B: Con SDKMAN**
```bash
sdk install karaf 4.4.5
```

#### 🪟 **Windows**

**Opción A: Instalación Manual**
```powershell
# Descargar desde el navegador:
# https://dlcdn.apache.org/karaf/4.4.5/apache-karaf-4.4.5.zip

# O con PowerShell:
Invoke-WebRequest -Uri "https://dlcdn.apache.org/karaf/4.4.5/apache-karaf-4.4.5.zip" -OutFile "karaf.zip"
Expand-Archive -Path karaf.zip -DestinationPath C:\
Rename-Item C:\apache-karaf-4.4.5 C:\karaf

# Agregar al PATH (variable de entorno del sistema)
# Panel de Control → Sistema → Configuración avanzada → Variables de entorno
# Agregar: C:\karaf\bin
```

**Opción B: Con Chocolatey**
```powershell
choco install apache-karaf
```

### 2️⃣ Compilar el Proyecto

#### 🍎 macOS / 🐧 Linux
```bash
# Navega al directorio del proyecto
cd /ruta/al/proyecto/ApacheKaraf
mvn clean install
```

#### 🪟 Windows (PowerShell o CMD)
```powershell
# Navega al directorio del proyecto
cd C:\ruta\al\proyecto\ApacheKaraf
mvn clean install
```

**Resultado esperado:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: ~3s
```

### 3️⃣ Iniciar Apache Karaf

#### 🍎 macOS / 🐧 Linux

```bash
karaf
```

O si instalaste manualmente:
```bash
/opt/karaf/bin/karaf
```

#### 🪟 Windows

```powershell
karaf.bat
```

O si instalaste manualmente:
```powershell
C:\karaf\bin\karaf.bat
```

Verás algo como:
```
        __ __                  ____      
       / //_/____ __________ _/ __/      
      / ,<  / __ `/ ___/ __ `/ /_        
     / /| |/ /_/ / /  / /_/ / __/        
    /_/ |_|\__,_/_/   \__,_/_/         

  Apache Karaf (4.4.5)

Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'system:shutdown' or 'logout' to shutdown Karaf.

karaf@root()>
```

> **Nota**: En Windows usa `Ctrl+D` o escribe `logout` para salir de Karaf

### 4️⃣ Instalar los Bundles en Karaf

Dentro de la consola de Karaf, ejecuta los siguientes comandos:

```bash
# Agregar el repositorio de features
karaf@root()> feature:repo-add mvn:org.example/features/1.0-SNAPSHOT/xml/features

# Listar las features disponibles
karaf@root()> feature:list | grep message
```

Deberías ver:
```
message-service-api       │ 1.0-SNAPSHOT  │          │ Uninstalled
message-service-impl      │ 1.0-SNAPSHOT  │          │ Uninstalled  
message-consumer          │ 1.0-SNAPSHOT  │          │ Uninstalled
message-demo              │ 1.0-SNAPSHOT  │          │ Uninstalled
```

### 5️⃣ Demostración del Bajo Acoplamiento

**Escenario 1: Consumer sin Servicio (demuestra tolerancia a fallos)**

```bash
# Instalar solo el consumer
karaf@root()> feature:install message-consumer

# Ver los logs en tiempo real
karaf@root()> log:tail
```

Verás mensajes como:
```
*************************************************
Iniciando Message Consumer Bundle...
*************************************************
Message Consumer iniciado - enviando mensajes cada 5 segundos
*************************************************
✗ MessageService no disponible - mensaje no enviado: Mensaje #1 desde Consumer
  (El bundle puede funcionar sin el servicio - bajo acoplamiento)
```

**Presiona Ctrl+C para salir del log tail**

**Escenario 2: Agregar el Servicio Dinámicamente**

```bash
# Instalar el servicio mientras el consumer está corriendo
karaf@root()> feature:install message-service-impl

# Ver los logs nuevamente
karaf@root()> log:tail
```

Verás cómo el consumer detecta el servicio automáticamente:
```
=================================================
Iniciando Message Service Bundle...
=================================================
Message Service registrado exitosamente!
=================================================
>>> MessageService DETECTADO: Message Service Implementation v1.0
    El consumer ahora puede procesar mensajes
✓ Respuesta recibida: [2025-11-12 12:50:00] Procesado: MENSAJE #2 DESDE CONSUMER
```

**Escenario 3: Detener y Reiniciar Bundles**

```bash
# Ver los bundles instalados
karaf@root()> bundle:list | grep message

# Ejemplo de salida:
# 75 │ Active │  80 │ 1.0.0.SNAPSHOT │ message-service-api
# 76 │ Active │  80 │ 1.0.0.SNAPSHOT │ message-service-impl
# 77 │ Active │  80 │ 1.0.0.SNAPSHOT │ message-consumer

# Detener el servicio (usa el ID de tu sistema)
karaf@root()> bundle:stop 76

# Ver logs - el consumer sigue funcionando pero reporta que no hay servicio
karaf@root()> log:tail

# Reiniciar el servicio
karaf@root()> bundle:start 76

# El consumer vuelve a procesar mensajes automáticamente
```

## 🎯 Comandos Útiles de Karaf

```bash
# Ver todos los bundles
karaf@root()> bundle:list

# Ver servicios OSGi registrados
karaf@root()> service:list

# Ver logs en tiempo real
karaf@root()> log:tail

# Ver logs anteriores
karaf@root()> log:display

# Cambiar nivel de log
karaf@root()> log:set DEBUG org.example

# Detener un bundle
karaf@root()> bundle:stop [ID]

# Iniciar un bundle
karaf@root()> bundle:start [ID]

# Desinstalar un feature
karaf@root()> feature:uninstall message-demo

# Salir de Karaf
karaf@root()> logout
```

## 📊 Flujo de Ejecución

```
┌─────────────────────┐
│  1. Karaf inicia    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  2. Instalar        │
│     consumer        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Consumer funciona  │
│  sin servicio       │ ◀── BAJO ACOPLAMIENTO
│  (reporta error)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  3. Instalar        │
│     servicio        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Consumer detecta   │
│  servicio y empieza │
│  a procesar mensajes│
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  4. Detener         │
│     servicio        │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Consumer sigue     │
│  funcionando pero   │
│  sin procesar       │ ◀── SISTEMA RESILIENTE
└─────────────────────┘
```

## 🐛 Solución de Problemas

### Error: "Maven no encuentra el feature repository"

#### 🍎 macOS / 🐧 Linux
```bash
# Asegúrate de que el proyecto esté compilado
mvn clean install

# Verifica que el archivo features.xml exista
ls ~/.m2/repository/org/example/features/1.0-SNAPSHOT/
```

#### 🪟 Windows
```powershell
# Asegúrate de que el proyecto esté compilado
mvn clean install

# Verifica que el archivo features.xml exista
dir %USERPROFILE%\.m2\repository\org\example\features\1.0-SNAPSHOT\
```

### Error: "Bundle no se puede resolver"

```bash
# Instala las dependencias en orden
karaf@root()> feature:install message-service-api
karaf@root()> feature:install message-service-impl
karaf@root()> feature:install message-consumer
```

### No ves los logs

```bash
# Aumenta el nivel de logging
karaf@root()> log:set DEBUG org.example
karaf@root()> log:tail
```

## 🎓 Conceptos Demostrados

1. **OSGi Service Registry**: Los servicios se registran y buscan dinámicamente
2. **Service Tracker**: Monitorea la disponibilidad de servicios
3. **Bundle Lifecycle**: Los bundles pueden iniciarse/detenerse independientemente
4. **Bajo Acoplamiento**: Los componentes solo conocen las interfaces, no las implementaciones
5. **Resilencia**: El sistema continúa funcionando incluso cuando fallan componentes

## 📚 Recursos Adicionales

- [Apache Karaf Documentation](https://karaf.apache.org/manual/latest/)
- [OSGi Specification](https://www.osgi.org/developer/specifications/)
- [Felix Bundle Plugin](https://felix.apache.org/documentation/subprojects/apache-felix-maven-bundle-plugin-bnd.html)

---

**¿Necesitas ayuda?** Revisa el README.md principal para más detalles.

