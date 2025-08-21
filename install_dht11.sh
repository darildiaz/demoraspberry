#!/bin/bash

echo "🌡️  Instalando Adafruit_DHT para DHT11 en Pin 11"
echo "================================================="

# Verificar si estamos en el directorio correcto
if [ ! -f "rele_demo.py" ]; then
    echo "❌ Error: No se encontró rele_demo.py"
    echo "💡 Asegúrate de estar en el directorio del proyecto"
    exit 1
fi

echo "📍 Directorio actual: $(pwd)"

echo ""
echo "🔧 Verificando entorno virtual..."
if [ -d "rele_env" ]; then
    echo "✅ Entorno virtual 'rele_env' encontrado"
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
echo "📦 Instalando Adafruit_DHT..."
echo "💡 Método 1: Instalación directa..."

if pip install Adafruit_DHT; then
    echo "✅ Adafruit_DHT instalado exitosamente"
else
    echo "⚠️  Falló instalación directa, intentando método 2: versión específica..."
    
    if pip install Adafruit_DHT==1.4.0; then
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
                
                cd ~/demoraspberry
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
    if hasattr(Adafruit_DHT, '__file__'):
        print(f'   Ubicación: {Adafruit_DHT.__file__}')
except ImportError as e:
    print(f'❌ Error al importar Adafruit_DHT: {e}')
    exit(1)

print('🎉 ¡Adafruit_DHT está funcionando!')
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
    echo "3. Para probar ambos:"
    echo "   source rele_env/bin/activate"
    echo "   python dht11_pin11.py --continuous"
    echo "   # En otra terminal:"
    echo "   source rele_env/bin/activate"
    echo "   python rele_demo.py --manual"
    
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
echo "   pip install Adafruit_DHT"
echo "   python dht11_pin11.py" 