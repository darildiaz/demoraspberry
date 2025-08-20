# 🔌 Conexiones del Sensor DHT11 con Raspberry Pi

## Diagrama de Conexiones

```
Sensor DHT11          Raspberry Pi
┌─────────────┐      ┌─────────────┐
│             │      │             │
│  VCC (3.3V) ├──────┤ 3.3V       │
│             │      │             │
│  DATA (GPIO)├──────┤ GPIO8 (Pin 24)│
│             │      │             │
│  GND        ├──────┤ GND         │
│             │      │             │
└─────────────┘      └─────────────┘
```

## Detalles de Conexión

### Sensor DHT11

- **VCC**: Conectar a 3.3V (NO usar 5V, puede dañar el sensor)
- **DATA**: Conectar a GPIO8 (Pin 24 en la placa física)
- **GND**: Conectar a cualquier pin GND

### Resistencia Pull-up (Opcional pero Recomendado)

Para mejorar la estabilidad de la señal, puedes agregar una resistencia pull-up de 4.7kΩ o 10kΩ entre VCC y DATA.

```
VCC (3.3V) ──┬───[4.7kΩ]───┬─── DATA (GPIO4)
              │              │
              └─── DHT11 ────┘
```

## Pines GPIO en Raspberry Pi

| Función | BCM | WiringPi | Pin Físico                   |
| ------- | --- | -------- | ---------------------------- |
| DATA    | 8   | 15       | 24                           |
| 3.3V    | -   | -        | 1 o 17                       |
| GND     | -   | -        | 6, 9, 14, 20, 25, 30, 34, 39 |

## Verificación de Conexiones

1. **Verificar alimentación**: El LED del sensor debe encenderse
2. **Verificar continuidad**: Usar multímetro para verificar conexiones
3. **Verificar pines**: Confirmar que GPIO4 esté libre y configurado correctamente

## Solución de Problemas

### Error "Failed to get reading"

- Verificar conexiones de alimentación
- Verificar que DATA esté conectado al pin correcto
- Verificar que no haya cortocircuitos

### Lecturas inestables

- Agregar resistencia pull-up de 4.7kΩ
- Verificar que el cable no sea muy largo
- Verificar que no haya interferencias electromagnéticas

### Sensor no responde

- Verificar voltaje de alimentación (debe ser 3.3V)
- Verificar que el sensor esté bien conectado
- Probar con otro sensor DHT11
