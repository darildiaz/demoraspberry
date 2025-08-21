#!/usr/bin/env python3
"""
Demo moderno para sensor DHT11 en Raspberry Pi usando Adafruit CircuitPython
Basado en: https://randomnerdtutorials.com/raspberry-pi-dht11-dht22-python/
Conectado al Pin 11 (GPIO17)
"""
import time
import sys

def detectar_biblioteca():
    """Detecta qué biblioteca DHT está disponible"""
    try:
        import adafruit_dht
        import board
        return "moderna", adafruit_dht, board
    except ImportError:
        try:
            import Adafruit_DHT
            return "clasica", Adafruit_DHT, None
        except ImportError:
            return None, None, None

def leer_sensor_moderno(dht, pin):
    """Lee los datos usando la biblioteca moderna"""
    try:
        temperatura = dht.temperature
        humedad = dht.humidity
        
        if temperatura is not None and humedad is not None:
            return temperatura, humedad
        else:
            return None, None
    except Exception as e:
        print(f"❌ Error al leer sensor moderno: {e}")
        return None, None

def leer_sensor_clasico(dht, pin):
    """Lee los datos usando la biblioteca clásica"""
    try:
        humedad, temperatura = dht.read_retry(dht.DHT11, pin)
        if humedad is not None and temperatura is not None:
            return temperatura, humedad
        else:
            return None, None
    except Exception as e:
        print(f"❌ Error al leer sensor clásico: {e}")
        return None, None

def mostrar_datos(temperatura, humedad, biblioteca):
    """Muestra los datos del sensor de forma formateada"""
    timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
    print("=" * 50)
    print(f"🌡️  DHT11 - Pin 11 (GPIO17) - {timestamp}")
    print(f"📚 Biblioteca: {biblioteca}")
    print("=" * 50)
    print(f"🌡️  Temperatura: {temperatura:.1f}°C")
    print(f"💧 Humedad: {humedad:.1f}%")
    print("=" * 50)

def modo_continuo(dht, pin, biblioteca, intervalo=5):
    """Modo de lectura continua del sensor"""
    print(f"🔄 Modo continuo - Lecturas cada {intervalo} segundos")
    print(f"📚 Biblioteca: {biblioteca}")
    print("📍 Pin 11 (GPIO17)")
    print("⏹️  Presiona Ctrl+C para detener")
    print()
    
    try:
        while True:
            if biblioteca == "moderna":
                temperatura, humedad = leer_sensor_moderno(dht, pin)
            else:
                temperatura, humedad = leer_sensor_clasico(dht, pin)
                
            if temperatura is not None and humedad is not None:
                mostrar_datos(temperatura, humedad, biblioteca)
            else:
                print(f"[{time.strftime('%H:%M:%S')}] ❌ Error en la lectura")
            
            time.sleep(intervalo)
    except KeyboardInterrupt:
        print("\n\n⏹️  Demo detenida por el usuario")
        print("👋 ¡Hasta luego!")

def modo_single(dht, pin, biblioteca):
    """Modo de lectura única del sensor"""
    print("📡 Modo de lectura única")
    print(f"📚 Biblioteca: {biblioteca}")
    print("📍 Pin 11 (GPIO17)")
    print()
    
    if biblioteca == "moderna":
        temperatura, humedad = leer_sensor_moderno(dht, pin)
    else:
        temperatura, humedad = leer_sensor_clasico(dht, pin)
        
    if temperatura is not None and humedad is not None:
        mostrar_datos(temperatura, humedad, biblioteca)
    else:
        print("❌ No se pudieron leer los datos del sensor")
        print("💡 Verifica las conexiones en el pin 11")

def inicializar_sensor_moderno(board_module):
    """Inicializa el sensor usando la biblioteca moderna"""
    try:
        import adafruit_dht
        # GPIO17 = Pin 11
        pin = board_module.D17
        dht = adafruit_dht.DHT11(pin)
        return dht, pin
    except Exception as e:
        print(f"❌ Error al inicializar sensor moderno: {e}")
        return None, None

def inicializar_sensor_clasico(dht_module):
    """Inicializa el sensor usando la biblioteca clásica"""
    try:
        # GPIO17 = Pin 11
        pin = 17
        return dht_module, pin
    except Exception as e:
        print(f"❌ Error al inicializar sensor clásico: {e}")
        return None, None

def mostrar_ayuda():
    """Muestra la ayuda del programa"""
    print("Uso: python dht11_modern.py [OPCIONES]")
    print()
    print("Opciones:")
    print("  --continuous, -c [intervalo]  Modo continuo con lecturas cada N segundos")
    print("  --help, -h                    Muestra esta ayuda")
    print()
    print("Ejemplos:")
    print("  python dht11_modern.py                    # Lectura única")
    print("  python dht11_modern.py --continuous      # Continuo cada 5 segundos")
    print("  python dht11_modern.py -c 10             # Continuo cada 10 segundos")
    print()
    print("📍 Conexiones:")
    print("  VCC  → 3.3V (Pin 1 o 17)")
    print("  DATA → GPIO17 (Pin 11)")
    print("  GND  → GND (Pin 6, 9, 14, 20, 25, 30, 34, 39)")

def main():
    """Función principal"""
    print("🌡️  Demo DHT11 Moderno - Pin 11 (GPIO17)")
    print("=" * 50)
    
    # Detectar biblioteca disponible
    tipo_biblioteca, dht_module, board_module = detectar_biblioteca()
    
    if tipo_biblioteca is None:
        print("❌ Error: No se encontró ninguna biblioteca DHT")
        print("💡 Instala con: pip install adafruit-circuitpython-dht")
        print("💡 O con: pip install Adafruit_DHT --force-pi")
        sys.exit(1)
    
    print(f"✅ Biblioteca detectada: {tipo_biblioteca}")
    
    # Inicializar sensor
    if tipo_biblioteca == "moderna":
        dht, pin = inicializar_sensor_moderno(board_module)
    else:
        dht, pin = inicializar_sensor_clasico(dht_module)
    
    if dht is None:
        print("❌ Error: No se pudo inicializar el sensor")
        sys.exit(1)
    
    # Procesar argumentos
    if len(sys.argv) > 1:
        if sys.argv[1] == "--continuous" or sys.argv[1] == "-c":
            intervalo = 5
            if len(sys.argv) > 2:
                try:
                    intervalo = int(sys.argv[2])
                except ValueError:
                    print("Intervalo inválido, usando 5 segundos por defecto")
            modo_continuo(dht, pin, tipo_biblioteca, intervalo)
        elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
            mostrar_ayuda()
        else:
            print("Argumento no reconocido. Usa --help para ver las opciones")
    else:
        modo_single(dht, pin, tipo_biblioteca)

if __name__ == "__main__":
    main() 