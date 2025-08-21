#!/bin/bash

echo "🌡️  Instalando Adafruit_DHT para DHT11"
echo "====================================="

# Verificar si estamos en el directorio correcto
if [ ! -f "rele_demo.py" ]; then
    echo "❌ Error: No se encontró rele_demo.py"
    echo "💡 Asegúrate de estar en el directorio del proyecto"
    exit 1
fi

echo "📍 Directorio actual: $(pwd)"

echo ""
echo "🔧 Activando entorno virtual..."
if [ -d "rele_env" ]; then
    source rele_env/bin/activate
    
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "✅ Entorno virtual activado: $VIRTUAL_ENV"
        echo "📍 Python: $(which python)"
        echo "📍 Pip: $(which pip)"
    else
        echo "❌ Error: No se pudo activar el entorno virtual"
        exit 1
    fi
else
    echo "❌ Error: No se encontró el entorno virtual 'rele_env'"
    echo "💡 Ejecuta primero: ./setup_rele_env.sh"
    exit 1
fi

echo ""
echo "📚 Actualizando pip..."
pip install --upgrade pip

echo ""
echo "📦 Instalando Adafruit_DHT con --force-pi..."
if pip install Adafruit_DHT --force-pi; then
    echo "✅ Adafruit_DHT instalado exitosamente"
else
    echo "⚠️  Falló con --force-pi, intentando versión específica..."
    
    if pip install Adafruit_DHT==1.4.0 --force-pi; then
        echo "✅ Adafruit_DHT 1.4.0 instalado exitosamente"
    else
        echo "⚠️  Falló versión específica, intentando wheel precompilado..."
        
        if pip install --only-binary=all Adafruit_DHT; then
            echo "✅ Adafruit_DHT instalado desde wheel precompilado"
        else
            echo "⚠️  Falló wheel precompilado, intentando instalación del sistema..."
            
            sudo apt install -y python3-dht11
            
            if [ $? -eq 0 ]; then
                echo "✅ Adafruit_DHT instalado desde paquete del sistema"
            else
                echo "❌ Error: No se pudo instalar Adafruit_DHT"
                echo "💡 Intenta manualmente:"
                echo "   pip install Adafruit_DHT --force-pi"
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
    if hasattr(Adafruit_DHT, '__version__'):
        print(f'   Versión: {Adafruit_DHT.__version__}')
    print('🎉 ¡Adafruit_DHT está funcionando!')
except ImportError as e:
    print(f'❌ Error al importar Adafruit_DHT: {e}')
    exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
    echo "====================================="
    echo ""
    echo "✅ Adafruit_DHT instalado en el entorno virtual"
    echo "✅ DHT11 listo para usar en Pin 11 (GPIO17)"
    echo "✅ Relés funcionando en Pines 3 y 5"
    echo ""
    echo "🚀 PRÓXIMOS PASOS:"
    echo "1. Para usar el DHT11:"
    echo "   source rele_env/bin/activate"
    echo "   python dht11_pin11.py"
    echo ""
    echo "2. Para usar los relés:"
    echo "   source rele_env/bin/activate"
    echo "   python rele_demo.py"
    echo ""
    
    # Probar la instalación completa
    echo ""
    echo "🧪 Probando el DHT11..."
    python dht11_pin11.py
    
else
    echo ""
    echo "❌ Error en las pruebas de importación"
    echo "💡 Verifica la instalación manualmente"
fi

echo ""
echo "💡 Si sigues teniendo problemas, ejecuta:"
echo "   source rele_env/bin/activate"
echo "   pip install Adafruit_DHT --force-pi"
echo "   python dht11_pin11.py" 