#!/bin/bash

echo "🔌 Instalando demo para relé en Raspberry Pi"
echo "============================================"

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo "Puede que algunas dependencias no funcionen en otros sistemas"
    echo ""
fi

# Actualizar el sistema
echo "📦 Actualizando el sistema..."
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias del sistema
echo "🔧 Instalando dependencias del sistema..."
sudo apt-get install -y python3-pip python3-dev python3-venv
sudo apt-get install -y git

# Instalar herramientas de desarrollo GPIO
echo "⚡ Instalando herramientas GPIO..."
sudo apt-get install -y python3-gpiozero

# Crear entorno virtual
echo "🐍 Creando entorno virtual..."
python3 -m venv rele_env
source rele_env/bin/activate

# Instalar dependencias de Python
echo "📚 Instalando dependencias de Python..."
pip install --upgrade pip
pip install RPi.GPIO

# Configurar permisos GPIO
echo "🔐 Configurando permisos GPIO..."
sudo usermod -a -G gpio $USER

echo ""
echo "✅ Instalación completada!"
echo ""
echo "Para activar el entorno virtual:"
echo "  source rele_env/bin/activate"
echo ""
echo "Para ejecutar la demo:"
echo "  python rele_demo.py"
echo ""
echo "Para ver todas las opciones:"
echo "  python rele_demo.py --help"
echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo "" 