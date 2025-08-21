# 🌡️ Demo Raspberry Pi: DHT11 + Dual Relé

Este proyecto te permite **monitorear temperatura y humedad** con un sensor DHT11 y **controlar dispositivos eléctricos** con un módulo dual relé en tu Raspberry Pi.

## 📋 Características

### 🌡️ Sensor DHT11

- ✅ **Monitoreo de temperatura** (0-50°C, ±2°C)
- ✅ **Monitoreo de humedad** (20-90%, ±5%)
- ✅ **Lectura continua** o única
- ✅ **Biblioteca moderna** Adafruit CircuitPython
- ✅ **Fallback automático** a biblioteca clásica

### 🔌 Dual Relé

- ✅ **Control independiente** de 2 relés
- ✅ **3 modos de operación**: Manual, Automático y Secuencia
- ✅ **Interfaz de línea de comandos** intuitiva
- ✅ **Configuración automática** del entorno
- ✅ **Manejo de errores** robusto

## 🛠️ Requisitos

### Hardware

- **Raspberry Pi** (cualquier modelo)
- **Sensor DHT11** (temperatura y humedad)
- **Módulo dual relé** (5V)
- **Cables de conexión** (breadboard opcional)
- **Resistencia pull-up** 4.7kΩ (opcional, para estabilidad)

### Software

- **Raspberry Pi OS** (anteriormente Raspbian)
- **Python 3.7+**
- **RPi.GPIO**
- **Adafruit CircuitPython DHT** (biblioteca moderna)

## 🔌 Conexiones

### 🌡️ Sensor DHT11 - Pin 11 (GPIO17)

```
Sensor DHT11          Raspberry Pi
┌─────────────┐      ┌─────────────┐
│             │      │             │
│  VCC (3.3V) ├──────┤ 3.3V (Pin 1)│
│             │      │             │
│  DATA (GPIO)├──────┤ GPIO17 (Pin 11)│
│             │      │             │
│  GND        ├──────┤ GND (Pin 6) │
│             │      │             │
└─────────────┘      └─────────────┘
```

**⚠️ IMPORTANTE**:

- **VCC debe ser 3.3V** (NO 5V, puede dañar el sensor)
- **Pin 11 = GPIO17** (BCM numbering)
- **GND común** con el resto del sistema

### 🔌 Dual Relé - Pines 3 y 5 (GPIO2 y GPIO3)

```
Módulo Dual Relé      Raspberry Pi
┌─────────────┐      ┌─────────────┐
│             │      │             │
│  VCC        ├──────┤ 5V (Pin 2)  │
│             │      │             │
│  GND        ├──────┤ GND (Pin 6) │
│             │      │             │
│  IN1        ├──────┤ GPIO2 (Pin 3)│
│             │      │             │
│  IN2        ├──────┤ GPIO3 (Pin 5)│
│             │      │             │
└─────────────┘      └─────────────┘
```

**⚠️ IMPORTANTE**:

- **VCC debe ser 5V** para el módulo relé
- **Pin 3 = GPIO2** (BCM numbering)
- **Pin 5 = GPIO3** (BCM numbering)

Ver archivos `conexiones_dht11_pin11.md` y `conexiones_rele.md` para diagramas detallados.

## 🚀 Instalación

### 🆕 Instalación Automática Completa

```bash
# Navegar al proyecto
cd ~/demoraspberry

# Dar permisos de ejecución
chmod +x setup_rele_env.sh
chmod +x install_dht11_modern.sh

# 1. Configurar entorno virtual para relés
./setup_rele_env.sh

# 2. Instalar DHT11 en el mismo entorno
./install_dht11_modern.sh
```

### 🔧 Instalación Manual

```bash
# Actualizar sistema
sudo apt-get update && sudo apt-get upgrade -y

# Instalar dependencias del sistema
sudo apt-get install -y python3-pip python3-dev python3-venv

# Crear entorno virtual
python3 -m venv rele_env
source rele_env/bin/activate

# Instalar RPi.GPIO para relés
pip install RPi.GPIO

# Instalar biblioteca DHT moderna
pip install adafruit-circuitpython-dht
```

## 📖 Uso

### 🔧 Activación del Entorno Virtual

```bash
cd ~/demoraspberry
source rele_env/bin/activate
```

### 🌡️ Usar el Sensor DHT11

#### Lectura única:

```bash
python dht11_modern.py
```

#### Modo continuo (cada 5 segundos):

```bash
python dht11_modern.py --continuous
```

#### Modo continuo personalizado:

```bash
python dht11_modern.py -c 10  # Cada 10 segundos
```

#### Ver ayuda:

```bash
python dht11_modern.py --help
```

### 🔌 Usar los Relés

#### Modo interactivo:

```bash
python rele_demo.py
```

#### Modo manual:

```bash
python rele_demo.py --manual
```

#### Modo automático:

```bash
python rele_demo.py --auto      # Cada 2 segundos
python rele_demo.py --auto 5    # Cada 5 segundos
```

#### Modo secuencia:

```bash
python rele_demo.py --sequence
```

#### Ver ayuda:

```bash
python rele_demo.py --help
```

## 📊 Ejemplo de Salida

### 🌡️ DHT11

```
🌡️  DHT11 - Pin 11 (GPIO17) - 2024-01-15 14:30:25
📚 Biblioteca: moderna
==================================================
🌡️  Temperatura: 23.5°C
💧 Humedad: 45.2%
==================================================
```

### 🔌 Dual Relé

```
🔌 Demo Dual Relé - Raspberry Pi
========================================
Selecciona un modo:
1. Manual (control por comandos)
2. Automático (alternancia automática)
3. Secuencia (patrón predefinido)
4. Salir

Selecciona una opción (1-4): 1

🎮 MODO MANUAL - Controla ambos relés
Comandos disponibles:
  on1/off1   - Activar/desactivar Relé 1
  on2/off2   - Activar/desactivar Relé 2
  onall/offall - Activar/desactivar ambos
  toggle1/2  - Alternar Relé 1 o 2
  status     - Mostrar estado
  quit       - Salir

Comando > on1
🔌 Relé 1 ACTIVADO (GPIO2, Pin 3)
```

## 🔧 Configuración Avanzada

### 🌡️ Cambiar Pin del DHT11

Edita `dht11_modern.py` y modifica:

```python
# Para biblioteca moderna
pin = board_module.D17  # Cambiar D17 por el GPIO deseado

# Para biblioteca clásica
pin = 17  # Cambiar 17 por el GPIO deseado
```

### 🔌 Cambiar Pines de los Relés

Edita `rele_demo.py` y modifica:

```python
RELE1_PIN = 2   # Cambiar GPIO2 por el deseado
RELE2_PIN = 3   # Cambiar GPIO3 por el deseado
```

### 🔄 Cambiar Tipo de Relé

Si tus relés se activan con HIGH en lugar de LOW:

```python
RELE_ACTIVO_BAJO = False  # Para relés activos alto
```

## 🐛 Solución de Problemas

### 🌡️ DHT11

#### Error: "No se pudo importar adafruit_dht"

```bash
source rele_env/bin/activate
pip install adafruit-circuitpython-dht
```

#### Error: "Failed to get reading"

- Verificar que **VCC esté en 3.3V** (NO 5V)
- Verificar conexiones en **Pin 11 (GPIO17)**
- Agregar resistencia pull-up de 4.7kΩ entre VCC y DATA

#### Error: "Timed out waiting for PulseIn message"

```bash
sudo apt-get install libgpiod2
```

### 🔌 Relés

#### Error: "No se pudo importar RPi.GPIO"

```bash
source rele_env/bin/activate
pip install RPi.GPIO
```

#### Error: "Permission denied"

```bash
sudo usermod -a -G gpio $USER
sudo reboot
```

#### Relé no responde

- Verificar conexiones del módulo relé
- Confirmar que GPIO2 y GPIO3 estén libres
- Verificar voltaje de alimentación (5V)

## 📁 Estructura del Proyecto

```
demorasp/
├── 🌡️  DHT11:
│   ├── dht11_modern.py           # Script principal moderno
│   ├── dht11_pin11.py            # Script clásico (fallback)
│   ├── conexiones_dht11_pin11.md # Conexiones DHT11
│   └── install_dht11_modern.sh   # Instalación DHT11
├── 🔌 Relés:
│   ├── rele_demo.py              # Script principal dual relé
│   ├── test_rele.py              # Script de pruebas
│   ├── conexiones_rele.md        # Conexiones dual relé
│   └── setup_rele_env.sh         # Configuración entorno
├── 📚 Documentación:
│   └── README.md                 # Este archivo
└── 🚀 Scripts de Instalación:
    ├── install_rele.sh           # Instalación solo relés
    └── install_dht11_simple.sh   # Instalación DHT11 clásico
```

## 🔍 Monitoreo y Logs

### 🌡️ Monitoreo DHT11 en segundo plano:

```bash
# Ejecutar en background
nohup python dht11_modern.py --continuous > dht11.log 2>&1 &

# Ver logs en tiempo real
tail -f dht11.log

# Detener proceso
pkill -f dht11_modern.py
```

### 🔌 Monitoreo relés en segundo plano:

```bash
# Ejecutar en background
nohup python rele_demo.py --auto > rele.log 2>&1 &

# Ver logs en tiempo real
tail -f rele.log

# Detener proceso
pkill -f rele_demo.py
```

## 📈 Proyectos de Extensión

### 🎯 Sistema de Ventilación Automática

```python
# Activar ventilador cuando temperatura > 25°C
# Desactivar cuando < 22°C
if temperatura > 25:
    activar_rele(1)  # Ventilador ON
elif temperatura < 22:
    desactivar_rele(1)  # Ventilador OFF
```

### 🌐 Control por Web

```python
from flask import Flask, render_template
app = Flask(__name__)

@app.route('/dht11/status')
def dht11_status():
    temp, hum = leer_sensor()
    return {'temperatura': temp, 'humedad': hum}

@app.route('/rele/<int:num>/<action>')
def control_rele(num, action):
    if action == 'on':
        activar_rele(num)
    elif action == 'off':
        desactivar_rele(num)
    return f'Relé {num} {action}'
```

### 📱 Control por MQTT

```python
import paho.mqtt.client as mqtt

def on_message(client, userdata, msg):
    if msg.topic == "casa/temperatura":
        temp = float(msg.payload.decode())
        if temp > 25:
            activar_rele(1)  # Ventilador
    elif msg.topic == "casa/rele/control":
        # Control remoto de relés
        pass
```

### 🤖 Control por Bot de Telegram

```python
from telegram.ext import Updater, CommandHandler

def temperatura(update, context):
    temp, hum = leer_sensor()
    update.message.reply_text(f'🌡️ {temp:.1f}°C, 💧 {hum:.1f}%')

def rele_on(update, context):
    num = int(context.args[0]) if context.args else 1
    activar_rele(num)
    update.message.reply_text(f'🔌 Relé {num} activado')
```

## 🎮 Comandos Rápidos

### 🌡️ DHT11

```bash
# Lectura rápida
source rele_env/bin/activate && python dht11_modern.py

# Monitoreo continuo
source rele_env/bin/activate && python dht11_modern.py -c 5
```

### 🔌 Relés

```bash
# Control manual
source rele_env/bin/activate && python rele_demo.py --manual

# Secuencia automática
source rele_env/bin/activate && python rele_demo.py --sequence
```

### 🔧 Mantenimiento

```bash
# Actualizar entorno
source rele_env/bin/activate && pip install --upgrade pip

# Verificar instalaciones
source rele_env/bin/activate && python -c "import adafruit_dht, RPi.GPIO; print('✅ Todo OK')"
```

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras un bug o tienes una mejora:

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🙏 Agradecimientos

- **Random Nerd Tutorials** por la documentación del DHT11
- **Adafruit** por las bibliotecas CircuitPython
- **Comunidad de Raspberry Pi** por el soporte continuo
- **Contribuidores** del proyecto

## 📞 Soporte

Si tienes problemas:

1. **Revisa esta documentación** completa
2. **Verifica las conexiones** del hardware
3. **Ejecuta los scripts de instalación** automática
4. **Consulta la documentación oficial** de Raspberry Pi
5. **Abre un issue** en el repositorio

## 🎯 Próximos Pasos

### 🚀 **Proyecto Recomendado: Sistema de Climatización Inteligente**

Combina ambos proyectos para crear un sistema que:

- **Monitoree temperatura** cada 10 segundos
- **Active ventilador** cuando suba de 25°C
- **Active calefacción** cuando baje de 18°C
- **Muestre estado** en tiempo real
- **Envíe alertas** por Telegram/Email

---

**¡Disfruta experimentando con tu Raspberry Pi!** 🚀

**🌡️ DHT11 + 🔌 Dual Relé = 🎯 Proyecto Completo**
