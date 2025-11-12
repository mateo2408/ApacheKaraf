# Configuración de IntelliJ IDEA

## 📌 Importar el Proyecto

### Todos los Sistemas Operativos (🪟 Windows | 🐧 Linux | 🍎 macOS)

1. Abre IntelliJ IDEA
2. **File → Open** (o **File → Open Project**)
3. Navega al directorio del proyecto `ApacheKaraf`
4. Selecciona el archivo `pom.xml`
5. Click en **"Open as Project"**
6. En el diálogo que aparece, selecciona **"Trust Project"**
7. Espera a que Maven sincronice todas las dependencias

> **Nota**: La primera vez puede tomar unos minutos mientras descarga las dependencias.

## 🔧 Configurar Source Roots (Si es necesario)

Si ves warnings de "Java file is located outside of the module source root":

### Para message-service-api:
1. Click derecho en `message-service-api/src/main/java`
2. Mark Directory as → Sources Root

### Para message-service-impl:
1. Click derecho en `message-service-impl/src/main/java`
2. Mark Directory as → Sources Root

### Para message-consumer:
1. Click derecho en `message-consumer/src/main/java`
2. Mark Directory as → Sources Root

## ✅ Verificar Configuración

1. File → Project Structure (⌘ + ;)
2. En "Project":
   - SDK: 21 (Amazon Corretto 21 o similar)
   - Language level: 21
3. En "Modules": Deberías ver 4 módulos
   - ApacheKaraf (parent)
   - message-service-api
   - message-service-impl
   - message-consumer
   - features

## 🚀 Ejecutar Maven desde IntelliJ

1. Abre la ventana de Maven (View → Tool Windows → Maven)
2. Expande "ApacheKaraf"
3. Lifecycle → clean → click derecho → Run
4. Lifecycle → install → click derecho → Run

O usa el terminal integrado:
```bash
mvn clean install
```

## 🎯 Ejecutar Karaf desde IntelliJ

1. Abre el Terminal integrado (View → Tool Windows → Terminal)
2. Ejecuta:
```bash
karaf
```

## 📝 Notas

- Los warnings de "outside module source root" son solo de IntelliJ y no afectan la compilación Maven
- El proyecto compila exitosamente con `mvn clean install`
- Los bundles OSGi se generan correctamente
- Todo está listo para usar en Apache Karaf

## 🔍 Estructura en IntelliJ

```
ApacheKaraf
├── .idea/                    (configuración IntelliJ)
├── message-service-api
│   └── src
│       └── main
│           └── java (SOURCE ROOT)
├── message-service-impl
│   └── src
│       └── main
│           └── java (SOURCE ROOT)
├── message-consumer
│   └── src
│       └── main
│           └── java (SOURCE ROOT)
├── features
│   └── src
│       └── main
│           └── resources
└── pom.xml
```

## 🐛 Solución de Problemas

### Problema: Maven no encuentra dependencias

**Solución**: 
- **File → Invalidate Caches / Restart**
- Selecciona **"Invalidate and Restart"**

### Problema: Errores de compilación en IDE

**Solución**: 
1. Reimportar proyecto Maven
   - Click en el botón **"Reload All Maven Projects"** en la ventana de Maven
   - O click derecho en `pom.xml` → **Maven → Reload Project**

2. Verificar configuración del SDK
   - **File → Project Structure → Project**
   - Asegúrate de que el SDK esté configurado correctamente

### Problema: No aparecen los módulos

**Solución**: 
1. **File → Project Structure → Modules**
2. Click en **"+"** → **Import Module**
3. Selecciona cada `pom.xml` de los submódulos manualmente

### Problema: Terminal no funciona correctamente

**🪟 Windows**: 
- Cambia el shell a PowerShell o CMD
- **File → Settings → Tools → Terminal**
- Shell path: `powershell.exe` o `cmd.exe`

**🍎 macOS / 🐧 Linux**: 
- Shell path debería ser `/bin/bash` o `/bin/zsh`

---

**Nota**: Aunque IntelliJ muestre algunos warnings, el proyecto funciona perfectamente con Maven y Karaf.

**Plataformas soportadas**: 🪟 Windows | 🐧 Linux | 🍎 macOS

