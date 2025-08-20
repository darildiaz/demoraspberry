#!/bin/bash

echo "🔧 SOLUCIÓN PARA ERROR 'externally-managed-environment'"
echo "======================================================"

# Verificar si estamos en Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo "⚠️  Advertencia: Este script está diseñado para Raspberry Pi"
    echo ""
fi

echo "📦 Instalando dependencias del sistema..."
sudo apt update
sudo apt install -y python3-venv python3-full python3-pip

echo ""
echo "🐍 Creando entorno virtual..."
python3 -m venv dht11_env

if [ $? -eq 0 ]; then
    echo "✅ Entorno virtual creado exitosamente"
    
    echo ""
    echo "🔧 Activando entorno virtual..."
    source dht11_env/bin/activate
    
    # Verificar que estamos en el entorno virtual
    if [[ "$VIRTUAL_ENV" != "" ]]; then
        echo "✅ Entorno virtual activado: $VIRTUAL_ENV"
        echo "📍 Python: $(which python)"
        echo "📍 Pip: $(which pip)"
        
        echo ""
        echo "📚 Actualizando pip en entorno virtual..."
        pip install --upgrade pip
        
        echo ""
        echo "📚 Instalando dependencias de Python..."
        
        # Intentar con requirements.txt principal
        if pip install -r requirements.txt; then
            echo "✅ Dependencias instaladas desde requirements.txt"
        else
            echo "⚠️  Falló requirements.txt, intentando con versiones alternativas..."
            
            # Instalar paquetes individuales con versiones disponibles
            echo "📦 Instalando RPi.GPIO..."
            pip install RPi.GPIO==0.7.0
            
            echo "📦 Instalando Adafruit_DHT con --force-pi..."
            pip install Adafruit_DHT --force-pi
            
            if [ $? -eq 0 ]; then
                echo "✅ Adafruit_DHT instalado exitosamente"
            else
                echo "⚠️  Falló instalación directa, intentando con dependencias del sistema..."
                
                # Instalar dependencias del sistema necesarias
                sudo apt install -y python3-dev python3-pip python3-setuptools
                sudo apt install -y build-essential libffi-dev libssl-dev
                sudo apt install -y python3-wheel
                
                # Intentar nuevamente
                pip install Adafruit_DHT --force-pi
            fi
            
            if [ $? -eq 0 ]; then
                echo "✅ Dependencias instaladas con versiones alternativas"
            else
                echo "⚠️  Intentando con versiones mínimas..."
                pip install "Adafruit_DHT>=1.3.4"
                pip install "RPi.GPIO>=0.7.0"
                
                if [ $? -eq 0 ]; then
                    echo "✅ Dependencias instaladas con versiones mínimas"
                else
                    echo "❌ Error: No se pudieron instalar las dependencias"
                    echo "💡 Intenta manualmente:"
                    echo "   pip install Adafruit_DHT RPi.GPIO"
                    exit 1
                fi
            fi
        fi
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "🎉 ¡INSTALACIÓN COMPLETADA EXITOSAMENTE!"
            echo "======================================"
            echo ""
            echo "✅ Entorno virtual creado y activado"
            echo "✅ Dependencias instaladas"
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
            echo "4. Para desactivar el entorno virtual:"
            echo "   deactivate"
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
            
            # Probar la instalación
            echo ""
            echo "🧪 Probando la instalación..."
            python test_dht11.py
            
        else
            echo ""
            echo "❌ Error al instalar dependencias"
            echo "💡 Intenta manualmente:"
            echo "   source dht11_env/bin/activate"
            echo "   pip install -r requirements.txt"
        fi
        
    else
        echo ""
        echo "❌ Error: No se pudo activar el entorno virtual"
        echo "💡 Intenta manualmente:"
        echo "   source dht11_env/bin/activate"
    fi
    
else
    echo ""
    echo "❌ Error: No se pudo crear el entorno virtual"
    echo "💡 Verifica que tengas python3-venv instalado:"
    echo "   sudo apt install python3-venv python3-full"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo "" 