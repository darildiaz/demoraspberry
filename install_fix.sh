#!/bin/bash

echo "🔧 Instalación para Raspberry Pi OS con Python gestionado externamente"
echo "=================================================================="

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo ""
fi

# Actualizar el sistema
echo "📦 Actualizando el sistema..."
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias del sistema
echo "🔧 Instalando dependencias del sistema..."
sudo apt-get install -y python3-pip python3-dev python3-venv python3-pip
sudo apt-get install -y git

# Instalar herramientas de desarrollo GPIO
echo "⚡ Instalando herramientas GPIO..."
sudo apt-get install -y python3-gpiozero

# Crear y activar entorno virtual
echo "🐍 Creando entorno virtual..."
python3 -m venv dht11_env

if [ $? -eq 0 ]; then
    echo "✅ Entorno virtual creado exitosamente"
    source dht11_env/bin/activate
    
    # Verificar que estamos en el entorno virtual
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "✅ Entorno virtual activado: $VIRTUAL_ENV"
        
        # Actualizar pip en el entorno virtual
        echo "📚 Actualizando pip en entorno virtual..."
        pip install --upgrade pip
        
        # Instalar dependencias
        echo "📚 Instalando dependencias de Python..."
        pip install -r requirements.txt
        
        if [ $? -eq 0 ]; then
            echo "✅ Dependencias instaladas exitosamente en entorno virtual"
        else
            echo "❌ Error al instalar dependencias en entorno virtual"
            exit 1
        fi
    else
        echo "❌ Error: No se pudo activar el entorno virtual"
        exit 1
    fi
else
    echo "❌ Error: No se pudo crear el entorno virtual"
    echo "Intentando instalación alternativa..."
    
    # Intentar con --break-system-packages
    echo "⚠️  Instalando con --break-system-packages..."
    pip install --break-system-packages -r requirements.txt
    
    if [ $? -eq 0 ]; then
        echo "✅ Dependencias instaladas con --break-system-packages"
    else
        echo "❌ Error: No se pudieron instalar las dependencias"
        echo "Intentando instalación manual..."
        
        # Instalación manual de paquetes
        echo "📦 Instalando paquetes individuales..."
        pip install --break-system-packages Adafruit_DHT
        pip install --break-system-packages RPi.GPIO
        
        if [ $? -eq 0 ]; then
            echo "✅ Paquetes instalados manualmente"
        else
            echo "❌ Error: Instalación manual falló"
            exit 1
        fi
    fi
fi

# Configurar permisos GPIO
echo "🔐 Configurando permisos GPIO..."
sudo usermod -a -G gpio $USER

echo ""
echo "✅ Instalación completada!"
echo ""

# Mostrar instrucciones según el método usado
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "🎯 ENTORNO VIRTUAL ACTIVADO:"
    echo "Para activar el entorno virtual en el futuro:"
    echo "  source dht11_env/bin/activate"
    echo ""
    echo "Para ejecutar la demo:"
    echo "  source dht11_env/bin/activate"
    echo "  python dht11_demo.py"
    echo ""
    echo "Para desactivar el entorno virtual:"
    echo "  deactivate"
else
    echo "🎯 INSTALACIÓN DIRECTA:"
    echo "Para ejecutar la demo:"
    echo "  python dht11_demo.py"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo ""

# Crear script de activación automática
echo "📝 Creando script de activación automática..."
cat > activar_env.sh << 'EOF'
#!/bin/bash
echo "🔧 Activando entorno virtual para DHT11..."
source dht11_env/bin/activate
echo "✅ Entorno virtual activado!"
echo "🌡️  Ejecuta: python dht11_demo.py"
echo "💡 Para desactivar: deactivate"
EOF

chmod +x activar_env.sh
echo "✅ Script 'activar_env.sh' creado para facilitar la activación del entorno" 