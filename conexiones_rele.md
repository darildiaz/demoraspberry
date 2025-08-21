# 🔌 Conexiones del Módulo Relé Doble con Raspberry Pi

## Diagrama de Conexiones

```
Módulo Relé Doble    Raspberry Pi
┌─────────────┐      ┌─────────────┐
│             │      │             │
│  VCC (5V)   ├──────┤ 5V          │
│             │      │             │
│  GND        ├──────┤ GND         │
│             │      │             │
│  IN1 (GPIO) ├──────┤ GPIO2 (Pin 3) │
│             │      │             │
│  IN2 (GPIO) ├──────┤ GPIO3 (Pin 5) │
│             │      │             │
└─────────────┘      └─────────────┘
```

## Detalles de Conexión

### Módulo Relé Doble

- **VCC**: Conectar a 5V (Pin 2 o 4)
- **GND**: Conectar a GND (cualquier pin)
- **IN1**: Conectar a GPIO2 (Pin 3) - Control Relé 1
- **IN2**: Conectar a GPIO3 (Pin 5) - Control Relé 2

### Pines GPIO en Raspberry Pi

| Función   | BCM | WiringPi | Pin Físico                   |
| --------- | --- | -------- | ---------------------------- |
| Control 1 | 2   | 8        | 3                            |
| Control 2 | 3   | 9        | 5                            |
| 5V        | -   | -        | 2 o 4                        |
| GND       | -   | -        | 6, 9, 14, 20, 25, 30, 34, 39 |

## Tipos de Relés

### Relé Activo Bajo (Low Level Trigger)

- Se activa cuando el pin GPIO está en LOW (0V)
- Más común en módulos de relé
- Configuración: `RELE_ACTIVO_BAJO = True`

### Relé Activo Alto (High Level Trigger)

- Se activa cuando el pin GPIO está en HIGH (3.3V)
- Menos común
- Configuración: `RELE_ACTIVO_BAJO = False`

## Verificación de Conexiones

1. **Verificar alimentación**: El LED del módulo relé debe encenderse
2. **Verificar continuidad**: Usar multímetro para verificar conexiones
3. **Verificar pines**: Confirmar que GPIO8 esté libre y configurado correctamente

## Solución de Problemas

### Relé no responde

- Verificar voltaje de alimentación (debe ser 5V)
- Verificar que el pin IN esté conectado al GPIO correcto
- Verificar que no haya cortocircuitos

### Relé se activa al revés

- Cambiar la configuración `RELE_ACTIVO_BAJO` en el código
- Verificar el tipo de relé que tienes

### Relé hace ruido

- Agregar condensador de 100µF entre VCC y GND
- Verificar que la fuente de alimentación sea estable

## Aplicaciones Comunes

- **Control de luces**: Encender/apagar lámparas
- **Control de ventiladores**: Activar/desactivar ventiladores
- **Control de motores**: Arrancar/parar motores pequeños
- **Control de electrodomésticos**: Activar/desactivar dispositivos

## Seguridad

⚠️ **IMPORTANTE**:

- Los relés pueden controlar voltajes altos (110V/220V)
- **NUNCA** toques los terminales de alta tensión
- Usa solo para voltajes que entiendas
- Si no estás seguro, consulta a un electricista
