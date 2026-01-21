#!/bin/bash
set -e 

# Garantizar que estamos en la raíz del proyecto
cd "$(dirname "$0")/.."

# 1. GESTIÓN DE ARGUMENTOS
# Si $1 existe úsalo, si no, usa "stm32f103c8t6" por defecto
TARGET_CHIP=${1:-stm32f103c8t6}
FIRMWARE_DIR="firmware_${TARGET_CHIP}"

# Argumento 2: Ruta del Toolchain (OPCIONAL)
# Si el usuario no pone nada, esta variable queda vacía.
USER_TOOLCHAIN_PATH=${2:-../cmake-toolchain/arm-toolchain.cmake}

echo "🔨 [BUILD] Iniciando compilación para: $TARGET_CHIP"

# 2. VALIDACIÓN DE CARPETA
# Si la carpeta firmware_CHIP no existe, detenemos todo con error.
if [ ! -d "$FIRMWARE_DIR" ]; then
    echo "❌ [ERROR] No se encuentra la carpeta: $FIRMWARE_DIR"
    echo "   Asegúrate de haber creado el proyecto para este chip."
    exit 1
fi

# 3. Limpieza
if [ -d "build_mcu" ]; then
    rm -rf build_mcu
fi
mkdir build_mcu
cd build_mcu

# 4. Configuración
# Pasamos la variable -DCHIP=$TARGET_CHIP a CMake
echo "⚙️  Configurando CMake..."

cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=$USER_TOOLCHAIN_PATH \
    -DCHIP=$TARGET_CHIP \
    -DBUILD_MODE=FIRMWARE \
    ..

# 5. Compilación
echo "🚀 Compilando..."
ninja

echo "✅ [EXITO] Firmware generado para $TARGET_CHIP"

