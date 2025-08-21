#!/bin/bash

echo "🔧 REPARACIÓN COMPLETA DEL SENSOR DHT11"
echo "======================================="

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo ""
fi

echo "🔐 VERIFICANDO PERMISOS DE USUARIO..."
echo "Usuario actual: $(whoami)"
echo "Grupos: $(groups)"
echo "UID: $(id -u)"
echo "GID: $(id -g)"

echo ""
echo "📦 VERIFICANDO CONEXIÓN A INTERNET..."
if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    echo "✅ Conexión a internet funcionando"
else
    echo "❌ Problema de conexión a internet"
    echo "💡 Verifica tu conexión WiFi/Ethernet"
    exit 1
fi

echo ""
echo "🧹 LIMPIEZA COMPLETA DEL SISTEMA..."
sudo apt update

# Desinstalar paquetes problemáticos del sistema
echo "🗑️  Desinstalando paquetes problemáticos..."
sudo apt remove -y python3-dht11 python3-rpi.gpio 2>/dev/null || true
sudo apt autoremove -y
sudo apt autoclean

echo ""
echo "📦 INSTALACIÓN COMPLETA DE DEPENDENCIAS..."
sudo apt install -y \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    python3-venv \
    build-essential \
    libffi-dev \
    libssl-dev \
    git \
    cmake \
    pkg-config \
    python3-gpiozero \
    python3-picamera2 \
    python3-libgpiod

echo ""
echo "🔧 REPARANDO PERMISOS..."
# Agregar usuario a grupos necesarios
sudo usermod -a -G gpio $USER
sudo usermod -a -G video $USER
sudo usermod -a -G spi $USER
sudo usermod -a -G i2c $USER

# Crear directorios necesarios con permisos correctos
sudo mkdir -p /usr/local/lib/python3.*/site-packages
sudo chown -R $USER:$USER /usr/local/lib/python3.*/site-packages 2>/dev/null || true

echo ""
echo "🐍 CREANDO NUEVO ENTORNO VIRTUAL LIMPIO..."
# Eliminar entorno virtual anterior si existe
if [ -d "dht11_env" ]; then
    echo "🗑️  Eliminando entorno virtual anterior..."
    rm -rf dht11_env
fi

# Crear nuevo entorno virtual
python3 -m venv dht11_env
source dht11_env/bin/activate

echo ""
echo "📍 Entorno virtual activado: $VIRTUAL_ENV"
echo "📍 Python: $(which python)"
echo "📍 Pip: $(which pip)"

echo ""
echo "📚 ACTUALIZANDO PIP Y HERRAMIENTAS..."
pip install --upgrade pip setuptools wheel

echo ""
echo "📦 INSTALANDO RPi.GPIO..."
if pip install RPi.GPIO; then
    echo "✅ RPi.GPIO instalado exitosamente"
else
    echo "❌ Error al instalar RPi.GPIO"
    echo "💡 Intentando instalación alternativa..."
    
    # Intentar con versión específica
    if pip install RPi.GPIO==0.7.0; then
        echo "✅ RPi.GPIO 0.7.0 instalado exitosamente"
    else
        echo "❌ Error: No se pudo instalar RPi.GPIO"
        exit 1
    fi
fi

echo ""
echo "📦 INSTALANDO Adafruit_DHT - MÉTODO ALTERNATIVO..."
echo "💡 Descargando y compilando desde GitHub..."

# Crear directorio temporal
cd /tmp
rm -rf Adafruit_Python_DHT 2>/dev/null || true

# Clonar repositorio
if git clone https://github.com/adafruit/Adafruit_Python_DHT.git; then
    echo "✅ Repositorio clonado exitosamente"
    cd Adafruit_Python_DHT
    
    # Verificar que estemos en el entorno virtual
    if [[ "$VIRTUAL_ENV" == "" ]]; then
        echo "⚠️  Entorno virtual no activado, activando..."
        cd ~/dht11_demo
        source dht11_env/bin/activate
        cd /tmp/Adafruit_Python_DHT
    fi
    
    echo "🔨 Compilando Adafruit_DHT..."
    
    # Intentar compilación con diferentes métodos
    if python setup.py install --user; then
        echo "✅ Adafruit_DHT compilado e instalado con --user"
    elif python setup.py install --force; then
        echo "✅ Adafruit_DHT compilado e instalado con --force"
    elif sudo python setup.py install; then
        echo "✅ Adafruit_DHT compilado e instalado con sudo"
    else
        echo "⚠️  Falló compilación estándar, intentando con pip..."
        
        # Volver al directorio del proyecto
        cd ~/dht11_demo
        source dht11_env/bin/activate
        
        # Intentar con pip desde el directorio local
        if pip install /tmp/Adafruit_Python_DHT; then
            echo "✅ Adafruit_DHT instalado desde directorio local"
        else
            echo "❌ Error: No se pudo instalar Adafruit_DHT por ningún método"
            echo "💡 Intentando método de último recurso..."
            
            # Método de último recurso: instalar en el sistema
            cd /tmp/Adafruit_Python_DHT
            sudo python3 setup.py install
            
            if [ $? -eq 0 ]; then
                echo "✅ Adafruit_DHT instalado en el sistema"
            else
                echo "❌ Error: Falló incluso la instalación en el sistema"
                echo "💡 Verifica que tengas permisos de administrador"
                exit 1
            fi
        fi
    fi
    
    # Limpiar archivos temporales
    cd ~/dht11_demo
    rm -rf /tmp/Adafruit_Python_DHT
    
else
    echo "❌ Error: No se pudo clonar el repositorio"
    echo "💡 Verifica la conexión a internet y permisos de git"
    exit 1
fi

echo ""
echo "🧪 PROBANDO INSTALACIÓN..."
source dht11_env/bin/activate

python -c "
import sys
print(f'Python: {sys.version}')
print(f'Path: {sys.path}')

try:
    import Adafruit_DHT
    print('✅ Adafruit_DHT importado correctamente')
    if hasattr(Adafruit_DHT, '__version__'):
        print(f'   Versión: {Adafruit_DHT.__version__}')
    if hasattr(Adafruit_DHT, '__file__'):
        print(f'   Ubicación: {Adafruit_DHT.__file__}')
except ImportError as e:
    print(f'❌ Error al importar Adafruit_DHT: {e}')
    print(f'   Tipo de error: {type(e).__name__}')
    
    # Intentar importar desde el sistema
    try:
        import sys
        sys.path.append('/usr/local/lib/python3.*/site-packages')
        import Adafruit_DHT
        print('✅ Adafruit_DHT importado desde sistema')
    except ImportError as e2:
        print(f'❌ Error también desde sistema: {e2}')
        exit(1)

try:
    import RPi.GPIO as GPIO
    print('✅ RPi.GPIO importado correctamente')
    if hasattr(GPIO, 'VERSION'):
        print(f'   Versión: {GPIO.VERSION}')
except ImportError as e:
    print(f'❌ Error al importar RPi.GPIO: {e}')
    exit(1)

print('🎉 ¡Todas las dependencias están funcionando!')
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡REPARACIÓN COMPLETADA EXITOSAMENTE!"
    echo "====================================="
    echo ""
    echo "✅ Sistema limpiado y actualizado"
    echo "✅ Permisos reparados"
    echo "✅ Dependencias del sistema instaladas"
    echo "✅ Entorno virtual recreado"
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
    echo "1. Verificar paquetes instalados:"
    echo "   pip list | grep -i dht"
    echo "   pip list | grep -i gpio"
    echo ""
    echo "2. Verificar instalación en sistema:"
    echo "   python3 -c 'import Adafruit_DHT; print(\"OK\")'"
    echo ""
    echo "3. Verificar permisos:"
    echo "   ls -la /usr/local/lib/python3.*/site-packages/ | grep -i dht"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo ""
echo "💡 Si sigues teniendo problemas, ejecuta:"
echo "   sudo reboot"
echo "   cd ~/dht11_demo"
echo "   source dht11_env/bin/activate"
echo "   python test_dht11.py" 