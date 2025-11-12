# Demo Apache Karaf - Bundles OSGi Interrelacionados

Este proyecto demuestra el uso de Apache Karaf con bundles OSGi que tienen bajo acoplamiento pero están interrelacionados.

✅ **PROYECTO COMPILADO EXITOSAMENTE** - Listo para usar con Apache Karaf

## 📋 Descripción

El proyecto consta de 4 módulos Maven:

1. **message-service-api**: Define la interfaz `MessageService` (contrato del servicio)
2. **message-service-impl**: Implementa el servicio de procesamiento de mensajes  
3. **message-consumer**: Consume el servicio y envía mensajes periódicamente
4. **features**: Descriptor de features de Karaf para instalación simplificada

### 🔑 Características Principales

- ✅ **Bajo Acoplamiento**: Los bundles se comunican a través de interfaces OSGi
- ✅ **Alta Cohesión**: Cada bundle tiene una responsabilidad clara y única
- ✅ **Inicio/Parada Dinámica**: Los bundles pueden iniciarse y detenerse sin afectar al sistema
- ✅ **Service Tracker**: El consumer detecta automáticamente cuando el servicio está disponible o no
- ✅ **Resiliente**: El sistema continúa funcionando incluso si un bundle se detiene

## 🛠️ Requisitos Previos

### En Mac (tu ambiente):

1. **Java 21** (ya lo tienes configurado)
2. **Maven** (para compilar)
3. **Apache Karaf 4.4.5** (necesitas descargarlo)

### Instalación de Apache Karaf en Mac:

```bash
# Opción 1: Con Homebrew (recomendado)
brew install karaf

# Opción 2: Descarga manual
cd ~/Downloads
curl -O https://dlcdn.apache.org/karaf/4.4.5/apache-karaf-4.4.5.tar.gz
tar -xzf apache-karaf-4.4.5.tar.gz
sudo mv apache-karaf-4.4.5 /opt/karaf
export PATH=$PATH:/opt/karaf/bin
```

## 🚀 Compilación del Proyecto

#### 🍎 macOS / 🐧 Linux

```bash
# En el directorio raíz del proyecto
cd /ruta/al/proyecto/ApacheKaraf
mvn clean install
```

#### 🪟 Windows (PowerShell o CMD)

```powershell
# En el directorio raíz del proyecto
cd C:\ruta\al\proyecto\ApacheKaraf
mvn clean install
```

**Resultado esperado:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: ~3s
```

## 🎮 Ejecución en Karaf

### 1. Iniciar Karaf

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

### 2. Configurar el repositorio Maven local (dentro de la consola Karaf)

```
karaf@root()> config:edit org.ops4j.pax.url.mvn
karaf@root()> config:property-set org.ops4j.pax.url.mvn.localRepository ~/.m2/repository
karaf@root()> config:update
```

### 3. Instalar el feature repository

```
karaf@root()> feature:repo-add mvn:org.example/features/1.0-SNAPSHOT/xml/features
```

### 4. Listar features disponibles

```
karaf@root()> feature:list | grep message
```

### 5. Instalar los bundles

Puedes instalarlos de varias formas:

**Opción A - Todo junto:**
```
karaf@root()> feature:install message-demo
```

**Opción B - Por separado (para demostrar el bajo acoplamiento):**
```
# Primero instala el consumer (verás que funciona sin el servicio)
karaf@root()> feature:install message-consumer

# Luego instala el servicio (verás cómo el consumer lo detecta)
karaf@root()> feature:install message-service-impl
```

## 🔍 Comandos Útiles en Karaf

### Ver bundles instalados
```
karaf@root()> bundle:list
```

### Ver servicios OSGi registrados
```
karaf@root()> service:list
```

### Ver logs en tiempo real
```
karaf@root()> log:tail
```

### Detener un bundle (por ID o nombre)
```
# Ver el ID del bundle
karaf@root()> bundle:list | grep message

# Detener por ID (ejemplo: ID 75)
karaf@root()> bundle:stop 75

# O por nombre
karaf@root()> bundle:stop message-service-impl
```

### Iniciar un bundle detenido
```
karaf@root()> bundle:start 75
# O
karaf@root()> bundle:start message-service-impl
```

### Desinstalar un bundle
```
karaf@root()> bundle:uninstall message-service-impl
```

## 🧪 Probando el Bajo Acoplamiento

### Prueba 1: Consumer sin Servicio

1. Instala solo el consumer:
   ```
   karaf@root()> feature:install message-consumer
   ```

2. Observa los logs - verás que el consumer funciona pero reporta que el servicio no está disponible
   ```
   karaf@root()> log:tail
   ```

### Prueba 2: Detección Automática del Servicio

1. Con el consumer ya corriendo, instala el servicio:
   ```
   karaf@root()> feature:install message-service-impl
   ```

2. Observa cómo el consumer detecta automáticamente el servicio y empieza a procesar mensajes

### Prueba 3: Detener y Reiniciar el Servicio

1. Detén el servicio:
   ```
   karaf@root()> bundle:stop message-service-impl
   ```

2. Observa que el consumer sigue funcionando pero no puede procesar mensajes

3. Reinicia el servicio:
   ```
   karaf@root()> bundle:start message-service-impl
   ```

4. El consumer vuelve a procesar mensajes automáticamente

## 📊 Arquitectura

```
┌─────────────────────────┐
│  message-service-api    │  ← Interfaz (contrato)
│  MessageService         │
└───────────┬─────────────┘
            │
            │ implements        │ depends on
            │                   │
    ┌───────▼────────┐     ┌────▼──────────────┐
    │ message-       │     │ message-consumer  │
    │ service-impl   │     │                   │
    │                │     │ (ServiceTracker)  │
    └────────┬───────┘     └────────┬──────────┘
             │                      │
             └──────────┬───────────┘
                        │
                   OSGi Service
                    Registry
```

### Bajo Acoplamiento:
- Los bundles solo dependen de la interfaz, no de la implementación
- Usan el Service Registry de OSGi para comunicarse
- Pueden funcionar de forma independiente

### Interrelación:
- El consumer usa el servicio a través de ServiceTracker
- El servicio se registra en el Service Registry de OSGi
- La comunicación es dinámica y flexible

## 🐛 Solución de Problemas

### Error: "Bundle could not be resolved"
- Asegúrate de que todos los módulos estén compilados: `mvn clean install`
- Verifica que el feature repository esté agregado correctamente

### Los bundles no aparecen en `bundle:list`
- Verifica que los features estén instalados: `feature:list | grep message`
- Revisa los logs: `log:display`

### No ves los logs
- Usa `log:tail` para ver logs en tiempo real
- Ajusta el nivel de log: `log:set DEBUG org.example`

## 📝 Notas Adicionales

- Los mensajes se envían cada 5 segundos por el consumer
- Los logs muestran claramente cuando los bundles se inician/detienen
- El ServiceTracker permite que el consumer funcione incluso sin el servicio disponible

## 🎯 Objetivos Cumplidos

✅ Apache Karaf implementado  
✅ 2 bundles funcionales (service-impl y consumer)  
✅ Bajo acoplamiento mediante interfaces OSGi  
✅ Interrelación mediante Service Registry  
✅ Bundles pueden iniciarse/detenerse independientemente  
✅ El sistema sigue funcionando al detener bundles  

---

**Autor**: Demo OSGi con Apache Karaf  
**Versión**: 1.0-SNAPSHOT  
**Java**: 21  
**Karaf**: 4.4.5

