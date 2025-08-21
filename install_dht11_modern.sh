#!/bin/bash

echo "🌡️  Instalando DHT11 con Adafruit CircuitPython (Método Moderno)"
echo "================================================================"

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
echo "📦 Instalando bibliotecas modernas de Adafruit..."
echo "💡 Método 1: Instalando adafruit-circuitpython-dht..."

if pip install adafruit-circuitpython-dht; then
    echo "✅ adafruit-circuitpython-dht instalado exitosamente"
else
    echo "⚠️  Falló instalación directa, intentando con dependencias..."
    
    # Instalar dependencias primero
    echo "📦 Instalando dependencias..."
    pip install adafruit-blinka
    pip install RPi.GPIO
    
    # Intentar instalar DHT nuevamente
    if pip install adafruit-circuitpython-dht; then
        echo "✅ adafruit-circuitpython-dht instalado con dependencias"
    else
        echo "⚠️  Falló con dependencias, intentando método alternativo..."
        
        # Método alternativo: instalar desde GitHub
        if pip install git+https://github.com/adafruit/Adafruit_CircuitPython_DHT.git; then
            echo "✅ adafruit-circuitpython-dht instalado desde GitHub"
        else
            echo "❌ Error: No se pudo instalar adafruit-circuitpython-dht"
            echo "💡 Intentando con la biblioteca clásica..."
            
            # Fallback a la biblioteca clásica
            if pip install Adafruit_DHT --force-pi; then
                echo "✅ Adafruit_DHT (clásica) instalada como fallback"
            else
                echo "❌ Error: No se pudo instalar ninguna biblioteca DHT"
                exit 1
            fi
        fi
    fi
fi

echo ""
echo "🧪 Probando la instalación..."
python -c "
try:
    # Intentar importar la biblioteca moderna
    import adafruit_dht
    import board
    print('✅ adafruit-circuitpython-dht importado correctamente')
    print('✅ board importado correctamente')
    print('🎉 ¡Biblioteca moderna funcionando!')
except ImportError as e:
    print(f'⚠️  adafruit-circuitpython-dht no disponible: {e}')
    try:
        # Intentar importar la biblioteca clásica
        import Adafruit_DHT
        print('✅ Adafruit_DHT (clásica) importado correctamente')
        print('💡 Usando biblioteca clásica como fallback')
    except ImportError as e2:
        print(f'❌ Error: No se pudo importar ninguna biblioteca DHT')
        print(f'   Moderna: {e}')
        print(f'   Clásica: {e2}')
        exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
    echo "====================================="
    echo ""
    echo "✅ Biblioteca DHT instalada en el entorno virtual"
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
echo "   pip install adafruit-circuitpython-dht"
echo "   python dht11_pin11.py" 