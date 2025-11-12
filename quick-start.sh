#!/bin/bash

# Script de inicio rápido para el demo de Karaf
# Este script compila el proyecto e inicia Karaf con configuración automática

set -e

# Detectar el directorio del proyecto automáticamente
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GROUP_ID="org.example"
ARTIFACT_ID="features"
VERSION="1.0-SNAPSHOT"

echo "================================================"
echo "Demo Apache Karaf - Inicio Rápido"
echo "================================================"
echo ""
echo "📂 Directorio del proyecto: $PROJECT_DIR"
echo ""

# Verificar Maven
if ! command -v mvn &> /dev/null; then
    echo "✗ Error: Maven no está instalado"
    exit 1
fi

# Compilar proyecto
echo "1. Compilando el proyecto..."
cd "$PROJECT_DIR"
mvn clean install -q
if [ $? -eq 0 ]; then
    echo "  ✓ Compilación exitosa"
else
    echo "  ✗ Error en la compilación"
    exit 1
fi
echo ""

# Verificar Karaf
echo "2. Verificando Apache Karaf..."
if command -v karaf &> /dev/null; then
    KARAF_CMD="karaf"
    echo "  ✓ Karaf encontrado en el PATH"
elif [ -f "/opt/karaf/bin/karaf" ]; then
    KARAF_CMD="/opt/karaf/bin/karaf"
    echo "  ✓ Karaf encontrado en /opt/karaf"
else
    echo "  ✗ Karaf no encontrado"
    echo ""
    echo "Por favor instala Karaf primero:"
    echo "  ./install-karaf.sh"
    exit 1
fi
echo ""

# Crear script de configuración de Karaf
KARAF_SCRIPT="/tmp/karaf-demo-setup.script"
cat > "$KARAF_SCRIPT" << 'EOF'
# Configurar repositorio Maven local
config:edit org.ops4j.pax.url.mvn
config:property-set org.ops4j.pax.url.mvn.localRepository ~/.m2/repository
config:update

# Esperar un momento
sleep 2

# Agregar feature repository
feature:repo-add mvn:org.example/features/1.0-SNAPSHOT/xml/features

# Esperar un momento
sleep 2

# Listar features disponibles
echo ""
echo "================================================"
echo "Features disponibles:"
echo "================================================"
feature:list | grep message

echo ""
echo "================================================"
echo "Para instalar los bundles, usa estos comandos:"
echo "================================================"
echo ""
echo "Opción 1 - Instalar todo:"
echo "  feature:install message-demo"
echo ""
echo "Opción 2 - Instalar por separado (recomendado para ver el bajo acoplamiento):"
echo "  feature:install message-consumer"
echo "  feature:install message-service-impl"
echo ""
echo "Comandos útiles:"
echo "  bundle:list                    - Ver bundles instalados"
echo "  log:tail                       - Ver logs en tiempo real"
echo "  bundle:stop [id|name]          - Detener un bundle"
echo "  bundle:start [id|name]         - Iniciar un bundle"
echo "  service:list                   - Ver servicios OSGi"
echo ""
EOF

echo "3. Iniciando Karaf..."
echo ""
echo "================================================"
echo "Karaf se iniciará con la configuración automática"
echo "================================================"
echo ""

# Iniciar Karaf
$KARAF_CMD < "$KARAF_SCRIPT"

# Limpiar
rm -f "$KARAF_SCRIPT"

