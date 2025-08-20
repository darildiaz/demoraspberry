#!/usr/bin/env python3
"""
Demo Avanzado para sensor DHT11 en Raspberry Pi
Incluye logging, estadísticas y guardado de datos
"""

import time
import sys
import csv
import json
import statistics
from datetime import datetime, timedelta
from pathlib import Path

try:
    import Adafruit_DHT
except ImportError:
    print("Error: No se pudo importar Adafruit_DHT")
    print("Instala las dependencias con: pip install -r requirements.txt")
    sys.exit(1)

class DHT11Monitor:
    """Clase para monitorear el sensor DHT11 con funcionalidades avanzadas"""
    
    def __init__(self, pin=8, sensor_type=Adafruit_DHT.DHT11):
        self.pin = pin
        self.sensor_type = sensor_type
        self.lecturas = []
        self.archivo_csv = "datos_dht11.csv"
        self.archivo_json = "estadisticas_dht11.json"
        
        # Crear directorio de datos si no existe
        Path("datos").mkdir(exist_ok=True)
        
        # Inicializar archivo CSV
        self.inicializar_csv()
    
    def inicializar_csv(self):
        """Inicializa el archivo CSV con encabezados"""
        try:
            with open(self.archivo_csv, 'w', newline='', encoding='utf-8') as file:
                writer = csv.writer(file)
                writer.writerow(['Timestamp', 'Temperatura_C', 'Humedad_%', 'Estado'])
        except Exception as e:
            print(f"Error al inicializar CSV: {e}")
    
    def leer_sensor(self):
        """Lee los datos del sensor DHT11"""
        try:
            humedad, temperatura = Adafruit_DHT.read_retry(self.sensor_type, self.pin)
            
            if humedad is not None and temperatura is not None:
                return temperatura, humedad, "OK"
            else:
                return None, None, "ERROR"
        except Exception as e:
            return None, None, f"EXCEPCION: {e}"
    
    def guardar_lectura(self, temperatura, humedad, estado):
        """Guarda una lectura en CSV y memoria"""
        timestamp = datetime.now()
        lectura = {
            'timestamp': timestamp,
            'temperatura': temperatura,
            'humedad': humedad,
            'estado': estado
        }
        
        # Guardar en memoria
        self.lecturas.append(lectura)
        
        # Mantener solo las últimas 1000 lecturas
        if len(self.lecturas) > 1000:
            self.lecturas = self.lecturas[-1000:]
        
        # Guardar en CSV
        try:
            with open(self.archivo_csv, 'a', newline='', encoding='utf-8') as file:
                writer = csv.writer(file)
                writer.writerow([
                    timestamp.strftime('%Y-%m-%d %H:%M:%S'),
                    temperatura if temperatura else '',
                    humedad if humedad else '',
                    estado
                ])
        except Exception as e:
            print(f"Error al guardar en CSV: {e}")
    
    def calcular_estadisticas(self):
        """Calcula estadísticas de las lecturas exitosas"""
        lecturas_ok = [l for l in self.lecturas if l['estado'] == 'OK']
        
        if not lecturas_ok:
            return None
        
        temperaturas = [l['temperatura'] for l in lecturas_ok]
        humedades = [l['humedad'] for l in lecturas_ok]
        
        stats = {
            'total_lecturas': len(self.lecturas),
            'lecturas_exitosas': len(lecturas_ok),
            'tasa_exito': len(lecturas_ok) / len(self.lecturas) * 100,
            'temperatura': {
                'min': min(temperaturas),
                'max': max(temperaturas),
                'promedio': statistics.mean(temperaturas),
                'mediana': statistics.median(temperaturas),
                'desv_estandar': statistics.stdev(temperaturas) if len(temperaturas) > 1 else 0
            },
            'humedad': {
                'min': min(humedades),
                'max': max(humedades),
                'promedio': statistics.mean(humedades),
                'mediana': statistics.median(humedades),
                'desv_estandar': statistics.stdev(humedades) if len(humedades) > 1 else 0
            },
            'ultima_actualizacion': datetime.now().isoformat()
        }
        
        return stats
    
    def guardar_estadisticas(self):
        """Guarda las estadísticas en archivo JSON"""
        stats = self.calcular_estadisticas()
        if stats:
            try:
                with open(self.archivo_json, 'w', encoding='utf-8') as file:
                    json.dump(stats, file, indent=2, ensure_ascii=False)
            except Exception as e:
                print(f"Error al guardar estadísticas: {e}")
    
    def mostrar_estadisticas(self):
        """Muestra las estadísticas en consola"""
        stats = self.calcular_estadisticas()
        
        if not stats:
            print("❌ No hay datos suficientes para calcular estadísticas")
            return
        
        print("\n" + "="*60)
        print("📊 ESTADÍSTICAS DEL SENSOR DHT11")
        print("="*60)
        print(f"📈 Total de lecturas: {stats['total_lecturas']}")
        print(f"✅ Lecturas exitosas: {stats['lecturas_exitosas']}")
        print(f"📊 Tasa de éxito: {stats['tasa_exito']:.1f}%")
        
        print(f"\n🌡️  TEMPERATURA:")
        print(f"   Mínima: {stats['temperatura']['min']:.1f}°C")
        print(f"   Máxima: {stats['temperatura']['max']:.1f}°C")
        print(f"   Promedio: {stats['temperatura']['promedio']:.1f}°C")
        print(f"   Mediana: {stats['temperatura']['mediana']:.1f}°C")
        print(f"   Desv. Estándar: {stats['temperatura']['desv_estandar']:.2f}°C")
        
        print(f"\n💧 HUMEDAD:")
        print(f"   Mínima: {stats['humedad']['min']:.1f}%")
        print(f"   Máxima: {stats['humedad']['max']:.1f}%")
        print(f"   Promedio: {stats['humedad']['promedio']:.1f}%")
        print(f"   Mediana: {stats['humedad']['mediana']:.1f}%")
        print(f"   Desv. Estándar: {stats['humedad']['desv_estandar']:.2f}%")
        
        print(f"\n🕒 Última actualización: {stats['ultima_actualizacion']}")
        print("="*60)
    
    def mostrar_ultimas_lecturas(self, cantidad=5):
        """Muestra las últimas lecturas"""
        print(f"\n📋 ÚLTIMAS {cantidad} LECTURAS:")
        print("-" * 60)
        
        for i, lectura in enumerate(self.lecturas[-cantidad:], 1):
            timestamp = lectura['timestamp'].strftime('%H:%M:%S')
            if lectura['estado'] == 'OK':
                print(f"{i}. [{timestamp}] 🌡️ {lectura['temperatura']:.1f}°C | 💧 {lectura['humedad']:.1f}%")
            else:
                print(f"{i}. [{timestamp}] ❌ {lectura['estado']}")
    
    def modo_monitoreo(self, duracion_minutos=60, intervalo=5):
        """Modo de monitoreo con estadísticas en tiempo real"""
        print(f"🔍 Modo monitoreo activado")
        print(f"⏱️  Duración: {duracion_minutos} minutos")
        print(f"📊 Intervalo: {intervalo} segundos")
        print("Presiona Ctrl+C para detener")
        print()
        
        inicio = datetime.now()
        fin = inicio + timedelta(minutes=duracion_minutos)
        
        try:
            while datetime.now() < fin:
                temperatura, humedad, estado = self.leer_sensor()
                
                # Guardar lectura
                self.guardar_lectura(temperatura, humedad, estado)
                
                # Mostrar lectura actual
                timestamp = datetime.now().strftime('%H:%M:%S')
                if estado == 'OK':
                    print(f"[{timestamp}] 🌡️ {temperatura:.1f}°C | 💧 {humedad:.1f}%")
                else:
                    print(f"[{timestamp}] ❌ {estado}")
                
                # Mostrar estadísticas cada 10 lecturas
                if len(self.lecturas) % 10 == 0:
                    self.mostrar_estadisticas()
                    self.guardar_estadisticas()
                
                time.sleep(intervalo)
                
        except KeyboardInterrupt:
            print("\n\n⏹️  Monitoreo detenido por el usuario")
        
        # Mostrar estadísticas finales
        print("\n📊 ESTADÍSTICAS FINALES:")
        self.mostrar_estadisticas()
        self.guardar_estadisticas()
        
        print(f"\n💾 Datos guardados en:")
        print(f"   CSV: {self.archivo_csv}")
        print(f"   JSON: {self.archivo_json}")

def main():
    """Función principal"""
    print("🌡️  Demo Avanzado Sensor DHT11 - Raspberry Pi")
    print("=" * 60)
    
    # Crear monitor
    monitor = DHT11Monitor()
    
    # Verificar argumentos
    if len(sys.argv) > 1:
        if sys.argv[1] == "--monitor" or sys.argv[1] == "-m":
            duracion = 60  # 1 hora por defecto
            if len(sys.argv) > 2:
                try:
                    duracion = int(sys.argv[2])
                except ValueError:
                    print("Duración inválida, usando 60 minutos por defecto")
            monitor.modo_monitoreo(duracion)
        elif sys.argv[1] == "--stats" or sys.argv[1] == "-s":
            monitor.mostrar_estadisticas()
        elif sys.argv[1] == "--recent" or sys.argv[1] == "-r":
            cantidad = 10
            if len(sys.argv) > 2:
                try:
                    cantidad = int(sys.argv[2])
                except ValueError:
                    print("Cantidad inválida, usando 10 por defecto")
            monitor.mostrar_ultimas_lecturas(cantidad)
        elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
            mostrar_ayuda()
        else:
            print("Argumento no reconocido. Usa --help para ver las opciones")
    else:
        # Modo interactivo
        print("Modo interactivo - Selecciona una opción:")
        print("1. Lectura única")
        print("2. Modo monitoreo (1 hora)")
        print("3. Ver estadísticas")
        print("4. Ver últimas lecturas")
        print("5. Salir")
        
        while True:
            try:
                opcion = input("\nSelecciona una opción (1-5): ").strip()
                
                if opcion == '1':
                    temperatura, humedad, estado = monitor.leer_sensor()
                    if estado == 'OK':
                        print(f"\n🌡️  Temperatura: {temperatura:.1f}°C")
                        print(f"💧 Humedad: {humedad:.1f}%")
                        monitor.guardar_lectura(temperatura, humedad, estado)
                    else:
                        print(f"❌ Error: {estado}")
                
                elif opcion == '2':
                    monitor.modo_monitoreo(60)
                    break
                
                elif opcion == '3':
                    monitor.mostrar_estadisticas()
                
                elif opcion == '4':
                    monitor.mostrar_ultimas_lecturas()
                
                elif opcion == '5':
                    print("¡Hasta luego!")
                    break
                
                else:
                    print("Opción inválida. Selecciona 1-5.")
                    
            except KeyboardInterrupt:
                print("\n\n¡Hasta luego!")
                break

def mostrar_ayuda():
    """Muestra la ayuda del programa"""
    print("Uso: python dht11_avanzado.py [OPCIONES]")
    print()
    print("Opciones:")
    print("  --monitor, -m [duracion]  Modo monitoreo por N minutos (default: 60)")
    print("  --stats, -s               Mostrar estadísticas")
    print("  --recent, -r [cantidad]  Mostrar últimas N lecturas (default: 10)")
    print("  --help, -h                Muestra esta ayuda")
    print()
    print("Ejemplos:")
    print("  python dht11_avanzado.py                    # Modo interactivo")
    print("  python dht11_avanzado.py --monitor         # Monitoreo 1 hora")
    print("  python dht11_avanzado.py -m 30             # Monitoreo 30 minutos")
    print("  python dht11_avanzado.py --stats           # Ver estadísticas")
    print("  python dht11_avanzado.py --recent 20       # Ver últimas 20 lecturas")

if __name__ == "__main__":
    main() 