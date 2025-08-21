# 🌡️ Conexiones del Sensor DHT11 en Pin 11

## Diagrama de Conexiones

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

## Detalles de Conexión

### Sensor DHT11

- **VCC**: Conectar a 3.3V (Pin 1) - ⚠️ NO usar 5V
- **DATA**: Conectar a GPIO17 (Pin 11)
- **GND**: Conectar a GND (Pin 6)

### Pines GPIO en Raspberry Pi

| Función | BCM | WiringPi | Pin Físico |
| ------- | --- | -------- | ---------- |
| DATA    | 17  | 0        | 11         |
| 3.3V    | -   | -        | 1          |
| GND     | -   | -        | 6          |

## Verificación de Conexiones

1. **Verificar alimentación**: El LED del sensor debe encenderse
2. **Verificar continuidad**: Usar multímetro para verificar conexiones
3. **Verificar pines**: Confirmar que GPIO17 esté libre y configurado correctamente

## Solución de Problemas

### Error "Failed to get reading"

- Verificar conexiones de alimentación (3.3V, NO 5V)
- Verificar que DATA esté conectado al pin 11
- Verificar que no haya cortocircuitos

### Lecturas inestables

- Agregar resistencia pull-up de 4.7kΩ entre VCC y DATA
- Verificar que el cable no sea muy largo
- Verificar que no haya interferencias electromagnéticas

### Sensor no responde

- Verificar voltaje de alimentación (debe ser 3.3V)
- Verificar que el sensor esté bien conectado
- Probar con otro sensor DHT11

## Uso del Script

```bash
# Activar entorno virtual
source rele_env/bin/activate

# Lectura única
python dht11_pin11.py

# Modo continuo
python dht11_pin11.py --continuous

# Modo continuo cada 10 segundos
python dht11_pin11.py -c 10
```

## Notas Importantes

- **Pin 11 (GPIO17)** es parte del bus SPI1, pero funciona perfectamente como GPIO
- **3.3V es obligatorio** - 5V puede dañar el sensor
- **GND común** con el resto del sistema
- **Resistencia pull-up** opcional pero recomendada para estabilidad
