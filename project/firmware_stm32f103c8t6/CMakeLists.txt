cmake_minimum_required(VERSION 3.22)

# ==============================================================================
# 🛠️ BLOQUE DE CONFIGURACIÓN DE USUARIO (¡EDITAR AQUÍ!) 🛠️
# ==============================================================================

# 1. Nombre del proyecto (El nombre de tu binario final)
set(TARGET_NAME "firmware_stm32f103c8t6")

# 2. Familia del MCU (Debe coincidir con la carpeta en Drivers/)
# Ejemplos: STM32F1xx, STM32F4xx, STM32L4xx
set(MCU_FAMILY "STM32F1xx")

# 3. Definición del Chip (Para el Pre-procesador -D)
# Busca esto en las propiedades de tu proyecto original o en main.h
set(MCU_DEF "STM32F103xB")

# 4. Arquitectura del Core (Para flags de compilación)
# Ejemplos: cortex-m3 (F1), cortex-m4 (F4/L4), cortex-m0plus (G0)
set(MCU_CORE "cortex-m3")

# 5. Archivos de Hardware (Scripts de Linker y Startup)
# Asegúrate de que estos archivos existan en la carpeta del firmware
set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/STM32F103XX_FLASH.ld")
set(STARTUP_FILE  "${CMAKE_CURRENT_SOURCE_DIR}/startup_stm32f103xb.s")

# ==============================================================================
# 🔚 FIN DE LA CONFIGURACIÓN (NO TOCAR NADA MÁS ABAJO) 🔚
# ==============================================================================

# Agregamos CXX para soportar C++ y ASM
project(${TARGET_NAME} C ASM CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17) # Estándar C++ moderno

# 1. Opciones de Compilación (CPU Flags)
# Usamos las variables definidas arriba
add_compile_options(
    -mcpu=${MCU_CORE}
    -mthumb
    -Wall
    -fdata-sections
    -ffunction-sections
    -g
    -Og
)

# 2. Definiciones Globales
add_definitions(
    -D${MCU_DEF}       # Define el chip (ej. -DSTM32F103xB)
    -DUSE_HAL_DRIVER   # Habilita la HAL
)

# 3. Include Directories (Construcción dinámica de rutas)
# Usa la variable ${MCU_FAMILY} para encontrar los drivers correctos automáticamente
include_directories(
    Core/Inc
    Drivers/${MCU_FAMILY}_HAL_Driver/Inc
    Drivers/${MCU_FAMILY}_HAL_Driver/Inc/Legacy
    Drivers/CMSIS/Device/ST/${MCU_FAMILY}/Include
    Drivers/CMSIS/Include
)

# 4. Fuentes (Sources)
# Busca automáticamente archivos .c y .cpp en Core y Drivers
file(GLOB_RECURSE SOURCES 
    "Core/Src/*.c"
    "Core/Src/*.cpp"
    "Drivers/${MCU_FAMILY}_HAL_Driver/Src/*.c"
)

# Filtro: Eliminamos templates de ST que a veces causan conflictos
list(FILTER SOURCES EXCLUDE REGEX ".*_template\\.c$")

# Validación del Startup File
if(NOT EXISTS ${STARTUP_FILE})
    message(FATAL_ERROR "❌ ERROR: No se encuentra el archivo de arranque: ${STARTUP_FILE}")
endif()

# 5. Crear el Ejecutable (.elf)
add_executable(${TARGET_NAME}.elf ${SOURCES} ${STARTUP_FILE})

# CONFIGURACIÓN DE LINKEO C++ vs C
# Si usas C++, es mejor usar LINKER_LANGUAGE CXX para que enlace las librerías std correctamente.
# Si tu proyecto fuera SOLO C, usarías 'C'.
set_target_properties(${TARGET_NAME}.elf PROPERTIES LINKER_LANGUAGE CXX)

# 6. Opciones de Linker
target_link_options(${TARGET_NAME}.elf PRIVATE
    -T${LINKER_SCRIPT}
    -mcpu=${MCU_CORE}
    -mthumb
    -Wl,--gc-sections
    -Wl,--print-memory-usage
    -Wl,-Map=${TARGET_NAME}.map
    --specs=nano.specs
    --specs=nosys.specs
)

# 7. Librerías Externas (Tu lógica de negocio)
# Enlazamos la librería 'app_lib' que viene del CMake padre
target_link_libraries(${TARGET_NAME}.elf PRIVATE app_lib)

# 8. Generación de Binarios (.bin y .hex) y Reporte de Tamaño
add_custom_command(TARGET ${TARGET_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary ${TARGET_NAME}.elf ${TARGET_NAME}.bin
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${TARGET_NAME}.elf ${TARGET_NAME}.hex
    COMMAND ${CMAKE_SIZE} ${TARGET_NAME}.elf
    COMMENT "🚀 Generando Binarios para ${MCU_DEF}: ${TARGET_NAME}.bin"
)