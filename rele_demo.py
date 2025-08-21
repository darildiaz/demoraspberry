#!/usr/bin/env python3
"""
Demo Simple para Relé en Raspberry Pi
Controla un relé conectado a GPIO para encender/apagar dispositivos
"""

import time
import sys
import RPi.GPIO as GPIO

# Configuración de los relés
RELE1_PIN = 2   # GPIO2 (Pin 3) - Relé 1
RELE2_PIN = 3   # GPIO3 (Pin 5) - Relé 2
RELE_ACTIVO_BAJO = True  # True si los relés se activan con LOW, False si con HIGH

def configurar_gpio():
    """Configura los pines GPIO para los relés"""
    try:
        # Configurar modo GPIO
        GPIO.setmode(GPIO.BCM)
        GPIO.setwarnings(False)
        
        # Configurar pines de los relés como salida
        GPIO.setup(RELE1_PIN, GPIO.OUT)
        GPIO.setup(RELE2_PIN, GPIO.OUT)
        
        # Estado inicial: relés desactivados
        estado_inicial = GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH
        GPIO.output(RELE1_PIN, estado_inicial)
        GPIO.output(RELE2_PIN, estado_inicial)
        
        print("✅ GPIO configurado correctamente")
        print(f"📍 Relé 1: GPIO{RELE1_PIN} (Pin 3)")
        print(f"📍 Relé 2: GPIO{RELE2_PIN} (Pin 5)")
        return True
        
    except Exception as e:
        print(f"❌ Error al configurar GPIO: {e}")
        return False

def activar_rele(numero_rele):
    """Activa el relé especificado (1 o 2)"""
    try:
        pin = RELE1_PIN if numero_rele == 1 else RELE2_PIN
        estado = GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH
        GPIO.output(pin, estado)
        print(f"🔌 Relé {numero_rele} ACTIVADO")
        return True
    except Exception as e:
        print(f"❌ Error al activar relé {numero_rele}: {e}")
        return False

def desactivar_rele(numero_rele):
    """Desactiva el relé especificado (1 o 2)"""
    try:
        pin = RELE1_PIN if numero_rele == 1 else RELE2_PIN
        estado = GPIO.HIGH if RELE_ACTIVO_BAJO else GPIO.LOW
        GPIO.output(pin, estado)
        print(f"🔌 Relé {numero_rele} DESACTIVADO")
        return True
    except Exception as e:
        print(f"❌ Error al desactivar relé {numero_rele}: {e}")
        return False

def alternar_rele(numero_rele):
    """Alterna el estado del relé especificado (1 o 2)"""
    try:
        pin = RELE1_PIN if numero_rele == 1 else RELE2_PIN
        estado_actual = GPIO.input(pin)
        nuevo_estado = GPIO.LOW if estado_actual == GPIO.HIGH else GPIO.HIGH
        GPIO.output(pin, nuevo_estado)
        
        if nuevo_estado == (GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH):
            print(f"🔌 Relé {numero_rele} ACTIVADO")
        else:
            print(f"🔌 Relé {numero_rele} DESACTIVADO")
            
        return True
    except Exception as e:
        print(f"❌ Error al alternar relé {numero_rele}: {e}")
        return False

def mostrar_estado():
    """Muestra el estado actual de ambos relés"""
    try:
        estado1 = GPIO.input(RELE1_PIN)
        estado2 = GPIO.input(RELE2_PIN)
        
        estado1_texto = "ACTIVADO" if estado1 == (GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH) else "DESACTIVADO"
        estado2_texto = "ACTIVADO" if estado2 == (GPIO.LOW if RELE_ACTIVO_BAJO else GPIO.HIGH) else "DESACTIVADO"
        
        print(f"🔌 Relé 1: {estado1_texto}")
        print(f"🔌 Relé 2: {estado2_texto}")
        return True
    except Exception as e:
        print(f"❌ Error al leer estado: {e}")
        return False

def activar_todos():
    """Activa ambos relés"""
    activar_rele(1)
    activar_rele(2)

def desactivar_todos():
    """Desactiva ambos relés"""
    desactivar_rele(1)
    desactivar_rele(2)

def alternar_todos():
    """Alterna el estado de ambos relés"""
    alternar_rele(1)
    alternar_rele(2)

def modo_manual():
    """Modo de control manual de los relés"""
    print("\n🎮 MODO MANUAL - Controla los relés con comandos")
    print("Comandos disponibles:")
    print("  on1      - Activar relé 1")
    print("  off1     - Desactivar relé 1")
    print("  toggle1  - Alternar relé 1")
    print("  on2      - Activar relé 2")
    print("  off2     - Desactivar relé 2")
    print("  toggle2  - Alternar relé 2")
    print("  onall    - Activar ambos relés")
    print("  offall   - Desactivar ambos relés")
    print("  toggleall- Alternar ambos relés")
    print("  status   - Mostrar estado de ambos")
    print("  quit     - Salir")
    print()
    
    while True:
        try:
            comando = input("Comando > ").strip().lower()
            
            if comando == "on1":
                activar_rele(1)
            elif comando == "off1":
                desactivar_rele(1)
            elif comando == "toggle1":
                alternar_rele(1)
            elif comando == "on2":
                activar_rele(2)
            elif comando == "off2":
                desactivar_rele(2)
            elif comando == "toggle2":
                alternar_rele(2)
            elif comando == "onall":
                activar_todos()
            elif comando == "offall":
                desactivar_todos()
            elif comando == "toggleall":
                alternar_todos()
            elif comando == "status":
                mostrar_estado()
            elif comando == "quit":
                print("👋 ¡Hasta luego!")
                break
            else:
                print("❌ Comando no válido.")
                print("💡 Comandos: on1, off1, toggle1, on2, off2, toggle2, onall, offall, toggleall, status, quit")
                
        except KeyboardInterrupt:
            print("\n\n👋 Modo manual interrumpido")
            break
        except Exception as e:
            print(f"❌ Error: {e}")

def modo_automatico(intervalo=2):
    """Modo automático con alternancia de los relés"""
    print(f"\n🤖 MODO AUTOMÁTICO - Alternando relés cada {intervalo} segundos")
    print("Patrón: Relé1 ON → Relé2 ON → Ambos OFF → Ambos ON")
    print("Presiona Ctrl+C para detener")
    print()
    
    try:
        paso = 0
        while True:
            if paso == 0:
                desactivar_todos()
                activar_rele(1)
                print("🔄 Paso 1: Solo Relé 1")
            elif paso == 1:
                desactivar_todos()
                activar_rele(2)
                print("🔄 Paso 2: Solo Relé 2")
            elif paso == 2:
                desactivar_todos()
                print("🔄 Paso 3: Ambos OFF")
            elif paso == 3:
                activar_todos()
                print("🔄 Paso 4: Ambos ON")
            
            paso = (paso + 1) % 4
            time.sleep(intervalo)
            
    except KeyboardInterrupt:
        print("\n\n⏹️  Modo automático detenido")
        # Asegurar que ambos relés estén desactivados al salir
        desactivar_todos()

def modo_secuencia():
    """Modo de secuencia predefinida para ambos relés"""
    print("\n🎭 MODO SECUENCIA - Ejecutando patrón predefinido")
    print("Secuencia: R1 ON → R2 ON → Ambos ON → R1 OFF → R2 OFF → Ambos OFF")
    print()
    
    secuencias = [
        ("Solo Relé 1 ON", lambda: (desactivar_todos(), activar_rele(1))),
        ("Solo Relé 2 ON", lambda: (desactivar_todos(), activar_rele(2))),
        ("Ambos relés ON", lambda: activar_todos()),
        ("Solo Relé 1 OFF", lambda: (activar_todos(), desactivar_rele(1))),
        ("Solo Relé 2 OFF", lambda: (activar_todos(), desactivar_rele(2))),
        ("Ambos relés OFF", lambda: desactivar_todos())
    ]
    
    duracion = 1.5  # segundos
    
    for i, (descripcion, accion) in enumerate(secuencias, 1):
        print(f"Paso {i}/6: {descripcion}")
        accion()
        time.sleep(duracion)
    
    print("\n✅ Secuencia completada")

def limpiar_gpio():
    """Limpia la configuración GPIO"""
    try:
        GPIO.cleanup()
        print("🧹 GPIO limpiado correctamente")
    except Exception as e:
        print(f"⚠️  Error al limpiar GPIO: {e}")

def main():
    """Función principal"""
    print("🔌 Demo Relé - Raspberry Pi")
    print("=" * 40)
    
    # Verificar argumentos de línea de comandos
    if len(sys.argv) > 1:
        if sys.argv[1] == "--manual" or sys.argv[1] == "-m":
            if configurar_gpio():
                modo_manual()
            limpiar_gpio()
        elif sys.argv[1] == "--auto" or sys.argv[1] == "-a":
            intervalo = 2
            if len(sys.argv) > 2:
                try:
                    intervalo = int(sys.argv[2])
                except ValueError:
                    print("Intervalo inválido, usando 2 segundos por defecto")
            if configurar_gpio():
                modo_automatico(intervalo)
            limpiar_gpio()
        elif sys.argv[1] == "--sequence" or sys.argv[1] == "-s":
            if configurar_gpio():
                modo_secuencia()
            limpiar_gpio()
        elif sys.argv[1] == "--help" or sys.argv[1] == "-h":
            mostrar_ayuda()
        else:
            print("Argumento no reconocido. Usa --help para ver las opciones")
    else:
        # Modo interactivo
        print("Selecciona un modo:")
        print("1. Manual (control por comandos)")
        print("2. Automático (alternancia automática)")
        print("3. Secuencia (patrón predefinido)")
        print("4. Salir")
        
        while True:
            try:
                opcion = input("\nSelecciona una opción (1-4): ").strip()
                
                if opcion == "1":
                    if configurar_gpio():
                        modo_manual()
                    limpiar_gpio()
                    break
                elif opcion == "2":
                    if configurar_gpio():
                        modo_automatico()
                    limpiar_gpio()
                    break
                elif opcion == "3":
                    if configurar_gpio():
                        modo_secuencia()
                    limpiar_gpio()
                    break
                elif opcion == "4":
                    print("👋 ¡Hasta luego!")
                    break
                else:
                    print("Opción inválida. Selecciona 1-4.")
                    
            except KeyboardInterrupt:
                print("\n\n👋 Demo interrumpida")
                break

def mostrar_ayuda():
    """Muestra la ayuda del programa"""
    print("Uso: python rele_demo.py [OPCIONES]")
    print()
    print("Opciones:")
    print("  --manual, -m           Modo manual con comandos")
    print("  --auto, -a [intervalo] Modo automático (default: 2 segundos)")
    print("  --sequence, -s         Modo secuencia predefinida")
    print("  --help, -h             Muestra esta ayuda")
    print()
    print("Ejemplos:")
    print("  python rele_demo.py                    # Modo interactivo")
    print("  python rele_demo.py --manual          # Control manual")
    print("  python rele_demo.py --auto 5          # Automático cada 5 segundos")
    print("  python rele_demo.py --sequence        # Secuencia predefinida")

if __name__ == "__main__":
    main() 