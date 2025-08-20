#!/usr/bin/env python3
"""
Script de prueba simple para el sensor DHT11
Verifica que las dependencias estén instaladas y el sensor funcione
"""

import sys
import time

def test_imports():
    """Prueba que las dependencias estén disponibles"""
    print("🔍 Probando importaciones...")
    
    try:
        import Adafruit_DHT
        print("✅ Adafruit_DHT importado correctamente")
        return True
    except ImportError as e:
        print(f"❌ Error al importar Adafruit_DHT: {e}")
        return False
    
    try:
        import RPi.GPIO as GPIO
        print("✅ RPi.GPIO importado correctamente")
        return True
    except ImportError as e:
        print(f"❌ Error al importar RPi.GPIO: {e}")
        return False

def test_sensor():
    """Prueba la lectura del sensor DHT11"""
    print("\n🌡️  Probando sensor DHT11...")
    
    try:
        import Adafruit_DHT
        
        # Configuración del sensor
        DHT_SENSOR = Adafruit_DHT.DHT11
        DHT_PIN = 8  # GPIO8 (Pin 24)
        
        print(f"📍 Pin configurado: GPIO{DHT_PIN}")
        print("📡 Intentando lectura del sensor...")
        
        # Intentar lectura
        humedad, temperatura = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
        
        if humedad is not None and temperatura is not None:
            print("✅ Sensor funcionando correctamente!")
            print(f"🌡️  Temperatura: {temperatura:.1f}°C")
            print(f"💧 Humedad: {humedad:.1f}%")
            return True
        else:
            print("⚠️  No se pudieron leer datos del sensor")
            print("💡 Verifica las conexiones del sensor")
            return False
            
    except Exception as e:
        print(f"❌ Error al probar el sensor: {e}")
        return False

def test_gpio():
    """Prueba el acceso a GPIO"""
    print("\n⚡ Probando acceso a GPIO...")
    
    try:
        import RPi.GPIO as GPIO
        
        # Configurar modo GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        
        # Probar pin de configuración
        test_pin = 8
        GPIO.setup(test_pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)
        
        # Leer estado del pin
        estado = GPIO.input(test_pin)
        print(f"✅ GPIO funcionando - Pin {test_pin}: {'HIGH' if estado else 'LOW'}")
        
        # Limpiar configuración
        GPIO.cleanup()
        return True
        
    except Exception as e:
        print(f"❌ Error al probar GPIO: {e}")
        return False

def main():
    """Función principal de pruebas"""
    print("🧪 PRUEBAS DEL SENSOR DHT11")
    print("=" * 40)
    
    # Verificar versión de Python
    print(f"🐍 Python {sys.version}")
    print(f"📍 Plataforma: {sys.platform}")
    
    # Probar importaciones
    imports_ok = test_imports()
    
    if not imports_ok:
        print("\n❌ PROBLEMAS CON LAS DEPENDENCIAS")
        print("💡 Soluciones:")
        print("   1. Activa el entorno virtual: source dht11_env/bin/activate")
        print("   2. Ejecuta: pip install -r requirements.txt")
        print("   3. O usa: pip install --break-system-packages -r requirements.txt")
        return
    
    # Probar GPIO
    gpio_ok = test_gpio()
    
    # Probar sensor
    sensor_ok = test_sensor()
    
    # Resumen
    print("\n" + "=" * 40)
    print("📊 RESUMEN DE PRUEBAS")
    print("=" * 40)
    print(f"📚 Dependencias: {'✅ OK' if imports_ok else '❌ FALLO'}")
    print(f"⚡ GPIO: {'✅ OK' if gpio_ok else '❌ FALLO'}")
    print(f"🌡️  Sensor: {'✅ OK' if sensor_ok else '❌ FALLO'}")
    
    if imports_ok and gpio_ok and sensor_ok:
        print("\n🎉 ¡TODAS LAS PRUEBAS PASARON!")
        print("🚀 Tu sensor DHT11 está listo para usar")
        print("\n💡 Próximos pasos:")
        print("   python dht11_demo.py --continuous")
        print("   python dht11_avanzado.py --monitor 30")
    else:
        print("\n⚠️  ALGUNAS PRUEBAS FALLARON")
        print("💡 Revisa las conexiones y configuración")
        
        if not imports_ok:
            print("   - Instala las dependencias")
        if not gpio_ok:
            print("   - Verifica permisos GPIO")
        if not sensor_ok:
            print("   - Verifica conexiones del sensor")

if __name__ == "__main__":
    main() 