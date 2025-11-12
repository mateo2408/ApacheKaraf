#!/bin/bash

# Script de instalación de Apache Karaf para Mac
# Este script descarga e instala Apache Karaf 4.4.5

set -e

KARAF_VERSION="4.4.5"
KARAF_DIR="/opt/karaf"
KARAF_ARCHIVE="apache-karaf-${KARAF_VERSION}.tar.gz"
KARAF_URL="https://dlcdn.apache.org/karaf/${KARAF_VERSION}/${KARAF_ARCHIVE}"

echo "================================================"
echo "Instalador de Apache Karaf ${KARAF_VERSION}"
echo "================================================"
echo ""

# Verificar si Karaf ya está instalado
if command -v karaf &> /dev/null; then
    echo "✓ Karaf ya está instalado en tu sistema"
    karaf version
    echo ""
    read -p "¿Deseas continuar con la instalación? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Instalación cancelada"
        exit 0
    fi
fi

# Verificar Java
echo "1. Verificando Java..."
if ! command -v java &> /dev/null; then
    echo "✗ Error: Java no está instalado"
    echo "  Por favor instala Java 21 primero"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
echo "  ✓ Java ${JAVA_VERSION} encontrado"
echo ""

# Verificar Homebrew
echo "2. Verificando Homebrew..."
if command -v brew &> /dev/null; then
    echo "  ✓ Homebrew encontrado"
    echo ""
    read -p "¿Deseas instalar Karaf con Homebrew? (recomendado) (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "  Instalando Karaf con Homebrew..."
        brew install karaf
        echo ""
        echo "================================================"
        echo "✓ Karaf instalado exitosamente con Homebrew"
        echo "================================================"
        echo ""
        echo "Para iniciar Karaf, ejecuta: karaf"
        echo ""
        exit 0
    fi
fi

# Instalación manual
echo "3. Instalación manual de Karaf..."
echo ""

# Crear directorio temporal
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo "  Descargando Apache Karaf ${KARAF_VERSION}..."
if command -v curl &> /dev/null; then
    curl -L -O "$KARAF_URL"
elif command -v wget &> /dev/null; then
    wget "$KARAF_URL"
else
    echo "✗ Error: ni curl ni wget están disponibles"
    exit 1
fi

echo "  ✓ Descarga completada"
echo ""

echo "  Extrayendo archivo..."
tar -xzf "$KARAF_ARCHIVE"
echo "  ✓ Extracción completada"
echo ""

echo "  Instalando en ${KARAF_DIR}..."
sudo rm -rf "$KARAF_DIR"
sudo mv "apache-karaf-${KARAF_VERSION}" "$KARAF_DIR"
sudo chown -R $(whoami) "$KARAF_DIR"
echo "  ✓ Instalación completada"
echo ""

# Agregar al PATH
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "KARAF_HOME" "$SHELL_CONFIG"; then
        echo ""
        echo "  Agregando Karaf al PATH en $SHELL_CONFIG..."
        echo "" >> "$SHELL_CONFIG"
        echo "# Apache Karaf" >> "$SHELL_CONFIG"
        echo "export KARAF_HOME=${KARAF_DIR}" >> "$SHELL_CONFIG"
        echo "export PATH=\$PATH:\$KARAF_HOME/bin" >> "$SHELL_CONFIG"
        echo "  ✓ PATH actualizado"
        echo ""
        echo "  IMPORTANTE: Ejecuta 'source $SHELL_CONFIG' o abre una nueva terminal"
    fi
fi

# Limpiar
cd -
rm -rf "$TEMP_DIR"

echo ""
echo "================================================"
echo "✓ Instalación completada exitosamente"
echo "================================================"
echo ""
echo "Ubicación: ${KARAF_DIR}"
echo ""
echo "Para iniciar Karaf, ejecuta:"
echo "  ${KARAF_DIR}/bin/karaf"
echo ""
echo "O si actualizaste el PATH:"
echo "  source ${SHELL_CONFIG}"
echo "  karaf"
echo ""

