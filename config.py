# Configuración del Sensor DHT11
# Modifica estos valores según tu configuración

# Tipo de sensor (DHT11 o DHT22)
SENSOR_TYPE = "DHT11"  # Opciones: "DHT11", "DHT22"

# Pin GPIO para el sensor (BCM numbering)
DHT_PIN = 8  # GPIO8 (Pin 24 en la placa física)

# Configuración de lectura
READ_RETRIES = 3      # Número de reintentos si falla la lectura
READ_DELAY = 2        # Delay entre lecturas (segundos)

# Configuración de archivos
CSV_FILENAME = "datos_dht11.csv"
JSON_FILENAME = "estadisticas_dht11.json"

# Configuración de monitoreo
DEFAULT_MONITOR_INTERVAL = 5      # Intervalo por defecto (segundos)
DEFAULT_MONITOR_DURATION = 60     # Duración por defecto (minutos)
MAX_READINGS_IN_MEMORY = 1000     # Máximo de lecturas en memoria

# Configuración de logging
LOG_LEVEL = "INFO"    # Opciones: "DEBUG", "INFO", "WARNING", "ERROR"
LOG_TO_FILE = True    # Guardar logs en archivo
LOG_FILENAME = "dht11.log"

# Configuración de alertas
TEMPERATURE_MIN = -10     # Temperatura mínima (°C)
TEMPERATURE_MAX = 50      # Temperatura máxima (°C)
HUMIDITY_MIN = 0          # Humedad mínima (%)
HUMIDITY_MAX = 100        # Humedad máxima (%)

# Configuración de red (para futuras funcionalidades)
ENABLE_NETWORK = False    # Habilitar funcionalidades de red
UPLOAD_INTERVAL = 300     # Intervalo de subida a servidor (segundos) 