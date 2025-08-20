#!/bin/bash

echo "🔧 SOLUCIÓN PARA ERROR DE COMPILACIÓN DE Adafruit_DHT"
echo "====================================================="

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo ""
fi

echo "📦 Instalando dependencias del sistema necesarias..."
sudo apt update
sudo apt install -y python3-dev python3-pip python3-setuptools
sudo apt install -y build-essential libffi-dev libssl-dev
sudo apt install -y python3-wheel python3-venv

echo ""
echo "🔧 Verificando entorno virtual..."
if [ -d "dht11_env" ]; then
    echo "✅ Entorno virtual encontrado"
    source dht11_env/bin/activate
else
    echo "🐍 Creando nuevo entorno virtual..."
    python3 -m venv dht11_env
    source dht11_env/bin/activate
fi

echo ""
echo "📍 Entorno virtual activado: $VIRTUAL_ENV"
echo "📍 Python: $(which python)"
echo "📍 Pip: $(which pip)"

echo ""
echo "📚 Actualizando pip..."
pip install --upgrade pip

echo ""
echo "📦 Instalando RPi.GPIO..."
if pip install RPi.GPIO; then
    echo "✅ RPi.GPIO instalado exitosamente"
else
    echo "❌ Error al instalar RPi.GPIO"
    exit 1
fi

echo ""
echo "📦 Instalando Adafruit_DHT con --force-pi..."
if pip install Adafruit_DHT --force-pi; then
    echo "✅ Adafruit_DHT instalado exitosamente"
else
    echo "⚠️  Falló con --force-pi, intentando alternativas..."
    
    echo ""
    echo "📦 Intentando con versión específica..."
    if pip install Adafruit_DHT==1.4.0 --force-pi; then
        echo "✅ Adafruit_DHT 1.4.0 instalado exitosamente"
    else
        echo "⚠️  Falló versión específica, intentando con wheel precompilado..."
        
        if pip install --only-binary=all Adafruit_DHT; then
            echo "✅ Adafruit_DHT instalado desde wheel precompilado"
        else
            echo "⚠️  Falló wheel precompilado, intentando instalación del sistema..."
            
            # Instalar paquete del sistema
            sudo apt install -y python3-dht11
            
            if [ $? -eq 0 ]; then
                echo "✅ Adafruit_DHT instalado desde paquete del sistema"
            else
                echo "❌ Error: No se pudo instalar Adafruit_DHT"
                echo "💡 Intenta manualmente:"
                echo "   sudo apt install python3-dht11"
                exit 1
            fi
        fi
    fi
fi

echo ""
echo "🧪 Probando la instalación..."
python -c "
try:
    import Adafruit_DHT
    print('✅ Adafruit_DHT importado correctamente')
except ImportError as e:
    print(f'❌ Error al importar Adafruit_DHT: {e}')
    exit(1)

try:
    import RPi.GPIO as GPIO
    print('✅ RPi.GPIO importado correctamente')
except ImportError as e:
    print(f'❌ Error al importar RPi.GPIO: {e}')
    exit(1)

print('🎉 ¡Todas las dependencias están funcionando!')
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
    echo "======================================"
    echo ""
    echo "✅ Dependencias del sistema instaladas"
    echo "✅ Entorno virtual configurado"
    echo "✅ RPi.GPIO instalado"
    echo "✅ Adafruit_DHT instalado"
    echo "✅ Sensor DHT11 listo para usar"
    echo ""
    echo "🚀 PRÓXIMOS PASOS:"
    echo "1. Para activar el entorno virtual en el futuro:"
    echo "   source dht11_env/bin/activate"
    echo ""
    echo "2. Para ejecutar la demo:"
    echo "   source dht11_env/bin/activate"
    echo "   python dht11_demo.py"
    echo ""
    echo "3. Para ejecutar pruebas:"
    echo "   source dht11_env/bin/activate"
    echo "   python test_dht11.py"
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
    echo "✅ Script 'activar.sh' creado para facilitar la activación"
    
    # Probar la instalación completa
    echo ""
    echo "🧪 Probando la instalación completa..."
    python test_dht11.py
    
else
    echo ""
    echo "❌ Error en las pruebas de importación"
    echo "💡 Verifica la instalación manualmente"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo "" 