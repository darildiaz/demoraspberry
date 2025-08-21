#!/usr/bin/env python3
"""
Script de prueba simple para el relé
Verifica que las conexiones y GPIO funcionen correctamente
"""

import time
import sys

def test_imports():
    """Prueba que las dependencias estén disponibles"""
    print("🔍 Probando importaciones...")
    
    try:
        import RPi.GPIO as GPIO
        print("✅ RPi.GPIO importado correctamente")
        return True
    except ImportError as e:
        print(f"❌ Error al importar RPi.GPIO: {e}")
        print("💡 Instala con: pip install RPi.GPIO")
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
        GPIO.setup(test_pin, GPIO.OUT)
        
        print(f"✅ GPIO configurado - Pin {test_pin}")
        
        # Probar salida
        GPIO.output(test_pin, GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(test_pin, GPIO.LOW)
        
        print("✅ Salida GPIO funcionando")
        
        # Limpiar configuración
        GPIO.cleanup()
        return True
        
    except Exception as e:
        print(f"❌ Error al probar GPIO: {e}")
        return False

def test_rele_basico():
    """Prueba básica de ambos relés"""
    print("\n🔌 Probando relés básicos...")
    
    try:
        import RPi.GPIO as GPIO
        
        # Configuración
        RELE1_PIN = 2
        RELE2_PIN = 3
        RELE_ACTIVO_BAJO = True
        
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        GPIO.setup(RELE1_PIN, GPIO.OUT)
        GPIO.setup(RELE2_PIN, GPIO.OUT)
        
        # Estado inicial: relés desactivados
        estado_inicial = GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH
        GPIO.output(RELE1_PIN, estado_inicial)
        GPIO.output(RELE2_PIN, estado_inicial)
        
        print("✅ Relés configurados correctamente")
        print("🔌 Relé 1 DESACTIVADO (estado inicial)")
        print("🔌 Relé 2 DESACTIVADO (estado inicial)")
        
        # Activar relé 1
        print("🔌 Activando relé 1...")
        estado_activado = GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH
        GPIO.output(RELE1_PIN, estado_activado)
        time.sleep(1)
        
        # Activar relé 2
        print("🔌 Activando relé 2...")
        GPIO.output(RELE2_PIN, estado_activado)
        time.sleep(1)
        
        # Desactivar ambos
        print("🔌 Desactivando ambos relés...")
        estado_desactivado = GPIO.HIGH if RELE_ACTIVO_BAJO else GPIO.LOW
        GPIO.output(RELE1_PIN, estado_desactivado)
        GPIO.output(RELE2_PIN, estado_desactivado)
        
        print("✅ Prueba básica de ambos relés completada")
        
        # Limpiar
        GPIO.cleanup()
        return True
        
    except Exception as e:
        print(f"❌ Error al probar relés: {e}")
        return False

def main():
    """Función principal de pruebas"""
    print("🧪 PRUEBAS DEL RELÉ - Raspberry Pi")
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
        print("   2. Ejecuta: pip install RPi.GPIO")
        print("   3. O usa: pip install --break-system-packages RPi.GPIO")
        return
    
    # Probar GPIO
    gpio_ok = test_gpio()
    
    # Probar relé
    rele_ok = test_rele_basico()
    
    # Resumen
    print("\n" + "=" * 40)
    print("📊 RESUMEN DE PRUEBAS")
    print("=" * 40)
    print(f"📚 Dependencias: {'✅ OK' if imports_ok else '❌ FALLO'}")
    print(f"⚡ GPIO: {'✅ OK' if gpio_ok else '❌ FALLO'}")
    print(f"🔌 Relés: {'✅ OK' if rele_ok else '❌ FALLO'}")
    
    if imports_ok and gpio_ok and rele_ok:
        print("\n🎉 ¡TODAS LAS PRUEBAS PASARON!")
        print("🚀 Tus relés están listos para usar")
        print("\n💡 Próximos pasos:")
        print("   python rele_demo.py --manual")
        print("   python rele_demo.py --auto 3")
        print("   python rele_demo.py --sequence")
    else:
        print("\n⚠️  ALGUNAS PRUEBAS FALLARON")
        print("💡 Revisa las conexiones y configuración")
        
        if not imports_ok:
            print("   - Instala las dependencias")
        if not gpio_ok:
            print("   - Verifica permisos GPIO")
        if not rele_ok:
            print("   - Verifica conexiones del relé")

if __name__ == "__main__":
    main() 