#!/usr/bin/env python3
"""
Demo para sensor DHT11 en Raspberry Pi
Este script lee temperatura y humedad del sensor DHT11 y muestra los datos
"""

import time
import sys
from datetime import datetime

try:
    import Adafruit_DHT
except ImportError:
    print("Error: No se pudo importar Adafruit_DHT")
    print("Instala las dependencias con: pip install -r requirements.txt")
    sys.exit(1)

# Configuración del sensor DHT11
DHT_SENSOR = Adafruit_DHT.DHT11
DHT_PIN = 8  # GPIO8 (Pin 24 en la placa)

def leer_sensor():
    """Lee los datos del sensor DHT11"""
    try:
        humedad, temperatura = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
        
        if humedad is not None and temperatura is not None:
            return temperatura, humedad
        else:
            return None, None
    except Exception as e:
        print(f"Error al leer el sensor: {e}")
        return None, None

def mostrar_datos(temperatura, humedad):
    """Muestra los datos del sensor de forma formateada"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    print("=" * 50)
    print(f"Lectura del sensor DHT11 - {timestamp}")
    print("=" * 50)
    print(f"🌡️  Temperatura: {temperatura:.1f}°C")
    print(f"💧 Humedad: {humedad:.1f}%")
    print("=" * 50)

def modo_continuo(intervalo=5):
    """Modo de lectura continua del sensor"""
    print(f"Modo continuo activado - Lecturas cada {intervalo} segundos")
    print("Presiona Ctrl+C para detener")
    print()
    
    try:
        while True:
            temperatura, humedad = leer_sensor()
            
            if temperatura is not None and humedad is not None:
                mostrar_datos(temperatura, humedad)
            else:
                print(f"[{datetime.now().strftime('%H:%M:%S')}] Error en la lectura del sensor")
            
            time.sleep(intervalo)
            
    except KeyboardInterrupt:
        print("\n\nDemo detenida por el usuario")
        print("¡Hasta luego!")

def modo_single():
    """Modo de lectura única del sensor"""
    print("Modo de lectura única")
    print()
    
    temperatura, humedad = leer_sensor()
    
    if temperatura is not None and humedad is not None:
        mostrar_datos(temperatura, humedad)
    else:
        print("❌ No se pudieron leer los datos del sensor")
        print("Verifica las conexiones y la configuración")

def main():
    """Función principal"""
    print("🌡️  Demo Sensor DHT11 - Raspberry Pi")
    print("=" * 50)
    
    # Verificar argumentos de línea de comandos
    if len(sys.argv) > 1:
        if sys.argv[1] == "--continuous" or sys.argv[1] == "-c":
            intervalo = 5
            if len(sys.argv) > 2:
                try:
                    intervalo = int(sys.argv[2])
                except ValueError:
                    print("Intervalo inválido, usando 5 segundos por defecto")
            modo_continuo(intervalo)
        elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
            mostrar_ayuda()
        else:
            print("Argumento no reconocido. Usa --help para ver las opciones")
    else:
        modo_single()

def mostrar_ayuda():
    """Muestra la ayuda del programa"""
    print("Uso: python dht11_demo.py [OPCIONES]")
    print()
    print("Opciones:")
    print("  --continuous, -c [intervalo]  Modo continuo con lecturas cada N segundos")
    print("  --help, -h                    Muestra esta ayuda")
    print()
    print("Ejemplos:")
    print("  python dht11_demo.py                    # Lectura única")
    print("  python dht11_demo.py --continuous      # Continuo cada 5 segundos")
    print("  python dht11_demo.py -c 10             # Continuo cada 10 segundos")

if __name__ == "__main__":
    main() 