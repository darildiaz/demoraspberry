#!/bin/bash

echo "🔍 DIAGNÓSTICO COMPLETO DEL SENSOR DHT11"
echo "========================================="

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo ""
fi

echo "📊 INFORMACIÓN DEL SISTEMA:"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Kernel: $(uname -r)"
echo "Arquitectura: $(uname -m)"
echo "Python3: $(python3 --version 2>/dev/null || echo 'No encontrado')"
echo "Pip3: $(pip3 --version 2>/dev/null || echo 'No encontrado')"

echo ""
echo "🔧 VERIFICANDO ENTORNO VIRTUAL..."
if [ -d "dht11_env" ]; then
    echo "✅ Entorno virtual encontrado"
    source dht11_env/bin/activate
    echo "📍 Entorno virtual activado: $VIRTUAL_ENV"
    echo "📍 Python: $(which python)"
    echo "📍 Pip: $(which pip)"
else
    echo "❌ No se encontró entorno virtual"
    echo "🐍 Creando nuevo entorno virtual..."
    python3 -m venv dht11_env
    source dht11_env/bin/activate
fi

echo ""
echo "📦 VERIFICANDO DEPENDENCIAS DEL SISTEMA..."
sudo apt update

# Lista de paquetes necesarios
packages=(
    "python3-dev"
    "python3-pip"
    "python3-setuptools"
    "python3-wheel"
    "build-essential"
    "libffi-dev"
    "libssl-dev"
    "git"
    "cmake"
    "pkg-config"
)

for package in "${packages[@]}"; do
    if dpkg -l | grep -q "^ii  $package"; then
        echo "✅ $package ya instalado"
    else
        echo "📦 Instalando $package..."
        sudo apt install -y "$package"
    fi
done

echo ""
echo "🧹 LIMPIANDO INSTALACIONES ANTERIORES..."
pip uninstall -y Adafruit_DHT RPi.GPIO 2>/dev/null || true
pip cache purge

echo ""
echo "📚 ACTUALIZANDO PIP..."
pip install --upgrade pip setuptools wheel

echo ""
echo "📦 INSTALANDO RPi.GPIO..."
if pip install RPi.GPIO; then
    echo "✅ RPi.GPIO instalado exitosamente"
else
    echo "❌ Error al instalar RPi.GPIO"
    echo "💡 Intentando instalación del sistema..."
    sudo apt install -y python3-rpi.gpio
fi

echo ""
echo "📦 INSTALANDO Adafruit_DHT..."
echo "💡 Intentando método 1: --force-pi..."

if pip install Adafruit_DHT --force-pi; then
    echo "✅ Adafruit_DHT instalado con --force-pi"
else
    echo "⚠️  Falló --force-pi, intentando método 2: versión específica..."
    
    if pip install Adafruit_DHT==1.4.0 --force-pi; then
        echo "✅ Adafruit_DHT 1.4.0 instalado exitosamente"
    else
        echo "⚠️  Falló versión específica, intentando método 3: wheel precompilado..."
        
        if pip install --only-binary=all Adafruit_DHT; then
            echo "✅ Adafruit_DHT instalado desde wheel precompilado"
        else
            echo "⚠️  Falló wheel precompilado, intentando método 4: instalación del sistema..."
            
            sudo apt install -y python3-dht11
            
            if [ $? -eq 0 ]; then
                echo "✅ Adafruit_DHT instalado desde paquete del sistema"
            else
                echo "⚠️  Falló paquete del sistema, intentando método 5: compilación manual..."
                
                echo "📦 Descargando y compilando Adafruit_DHT manualmente..."
                cd /tmp
                git clone https://github.com/adafruit/Adafruit_Python_DHT.git
                cd Adafruit_Python_DHT
                
                if python3 setup.py install --force; then
                    echo "✅ Adafruit_DHT compilado e instalado manualmente"
                else
                    echo "❌ Error: No se pudo instalar Adafruit_DHT por ningún método"
                    echo "💡 Verifica la conexión a internet y los permisos"
                    exit 1
                fi
                
                cd ~/dht11_demo
            fi
        fi
    fi
fi

echo ""
echo "🧪 PROBANDO IMPORTACIONES..."
python -c "
import sys
print(f'Python: {sys.version}')
print(f'Path: {sys.path}')

try:
    import Adafruit_DHT
    print('✅ Adafruit_DHT importado correctamente')
    print(f'   Versión: {Adafruit_DHT.__version__}')
    print(f'   Ubicación: {Adafruit_DHT.__file__}')
except ImportError as e:
    print(f'❌ Error al importar Adafruit_DHT: {e}')
    print(f'   Tipo de error: {type(e).__name__}')
    exit(1)

try:
    import RPi.GPIO as GPIO
    print('✅ RPi.GPIO importado correctamente')
    print(f'   Versión: {GPIO.VERSION}')
except ImportError as e:
    print(f'❌ Error al importar RPi.GPIO: {e}')
    exit(1)

print('🎉 ¡Todas las dependencias están funcionando!')
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡DIAGNÓSTICO COMPLETADO EXITOSAMENTE!"
    echo "======================================="
    echo ""
    echo "✅ Dependencias del sistema instaladas"
    echo "✅ Entorno virtual configurado"
    echo "✅ RPi.GPIO funcionando"
    echo "✅ Adafruit_DHT funcionando"
    echo "✅ Sensor DHT11 listo para usar"
    echo ""
    
    # Crear script de activación automática
    echo "📝 Creando script de activación automática..."
    cat > activar.sh << 'EOF'
#!/bin/bash
echo "🔧 Activando entorno virtual para DHT11..."
source dht11_env/bin/activate
echo "✅ Entorno virtual activado!"
echo "🌡️  Ejecuta: python dht11_demo.py"
echo "🧪 O prueba: python test_dht11.py"
echo "💡 Para desactivar: deactivate"
EOF

    chmod +x activar.sh
    echo "✅ Script 'activar.sh' creado"
    
    # Probar la instalación completa
    echo ""
    echo "🧪 Probando la instalación completa..."
    python test_dht11.py
    
else
    echo ""
    echo "❌ Error en las pruebas de importación"
    echo "💡 Verifica la instalación manualmente"
    
    echo ""
    echo "🔍 DIAGNÓSTICO ADICIONAL:"
    echo "1. Verificar que estés en el entorno virtual:"
    echo "   echo \$VIRTUAL_ENV"
    echo ""
    echo "2. Verificar paquetes instalados:"
    echo "   pip list | grep -i dht"
    echo "   pip list | grep -i gpio"
    echo ""
    echo "3. Verificar permisos:"
    echo "   ls -la dht11_env/lib/python*/site-packages/ | grep -i dht"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo "" 