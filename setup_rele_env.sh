#!/bin/bash

echo "🔌 Configurando entorno virtual para proyecto del relé"
echo "====================================================="

# Verificar si estamos en el directorio correcto
if [ ! -f "rele_demo.py" ]; then
    echo "❌ Error: No se encontró rele_demo.py"
    echo "💡 Asegúrate de estar en el directorio del proyecto del relé"
    exit 1
fi

echo "📍 Directorio actual: $(pwd)"
echo "📁 Archivos del proyecto:"
ls -la *.py *.md *.sh 2>/dev/null || echo "No se encontraron archivos del proyecto"

echo ""
echo "🧹 Limpiando entornos virtuales anteriores..."
# Eliminar entornos virtuales anteriores si existen
rm -rf dht11_env 2>/dev/null || true
rm -rf rele_env 2>/dev/null || true

echo ""
echo "🐍 Creando nuevo entorno virtual para el relé..."
python3 -m venv rele_env

if [ $? -eq 0 ]; then
    echo "✅ Entorno virtual creado exitosamente"
else
    echo "❌ Error al crear entorno virtual"
    echo "💡 Verifica que tengas python3-venv instalado:"
    echo "   sudo apt install python3-venv"
    exit 1
fi

echo ""
echo "🔧 Activando entorno virtual..."
source rele_env/bin/activate

# Verificar que esté activado
if [[ "$VIRTUAL_ENV" != "" ]]; then
    echo "✅ Entorno virtual activado: $VIRTUAL_ENV"
    echo "📍 Python: $(which python)"
    echo "📍 Pip: $(which pip)"
else
    echo "❌ Error: No se pudo activar el entorno virtual"
    exit 1
fi

echo ""
echo "📚 Actualizando pip..."
pip install --upgrade pip

echo ""
echo "📦 Instalando RPi.GPIO..."
if pip install RPi.GPIO; then
    echo "✅ RPi.GPIO instalado exitosamente"
else
    echo "❌ Error al instalar RPi.GPIO"
    echo "💡 Intentando con --break-system-packages..."
    pip install --break-system-packages RPi.GPIO
    
    if [ $? -eq 0 ]; then
        echo "✅ RPi.GPIO instalado con --break-system-packages"
    else
        echo "❌ Error: No se pudo instalar RPi.GPIO"
        exit 1
    fi
fi

echo ""
echo "🧪 Probando la instalación..."
python -c "
try:
    import RPi.GPIO as GPIO
    print('✅ RPi.GPIO importado correctamente')
    print(f'   Versión: {GPIO.VERSION}')
except ImportError as e:
    print(f'❌ Error al importar RPi.GPIO: {e}')
    exit(1)

print('🎉 ¡Dependencias instaladas correctamente!')
"

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ¡ENTORNO VIRTUAL CONFIGURADO EXITOSAMENTE!"
    echo "============================================"
    echo ""
    echo "✅ Entorno virtual 'rele_env' creado"
    echo "✅ RPi.GPIO instalado"
    echo "✅ Proyecto del relé listo para usar"
    echo ""
    echo "🚀 PRÓXIMOS PASOS:"
    echo "1. Para activar el entorno virtual en el futuro:"
    echo "   source rele_env/bin/activate"
    echo ""
    echo "2. Para ejecutar la demo:"
    echo "   source rele_env/bin/activate"
    echo "   python rele_demo.py"
    echo ""
    echo "3. Para ejecutar pruebas:"
    echo "   source rele_env/bin/activate"
    echo "   python test_rele.py"
    echo ""
    echo "4. Para desactivar el entorno virtual:"
    echo "   deactivate"
    echo ""
    
    # Crear script de activación automática
    echo "📝 Creando script de activación automática..."
    cat > activar.sh << 'EOF'
#!/bin/bash
echo "🔧 Activando entorno virtual para proyecto del relé..."
source rele_env/bin/activate
echo "✅ Entorno virtual activado!"
echo "🌡️  Ejecuta: python rele_demo.py"
echo "🧪 O prueba: python test_rele.py"
echo "💡 Para desactivar: deactivate"
EOF

    chmod +x activar.sh
    echo "✅ Script 'activar.sh' creado para facilitar la activación"
    
    # Probar la instalación completa
    echo ""
    echo "🧪 Probando la instalación completa..."
    python test_rele.py
    
else
    echo ""
    echo "❌ Error en las pruebas de importación"
    echo "💡 Verifica la instalación manualmente"
fi

echo ""
echo "⚠️  IMPORTANTE: Reinicia tu Raspberry Pi para que los cambios de permisos surtan efecto"
echo ""
echo "💡 Si sigues teniendo problemas, ejecuta:"
echo "   sudo reboot"
echo "   cd ~/demoraspberry"
echo "   source rele_env/bin/activate"
echo "   python test_rele.py" 