#!/bin/bash
# Detenerse si hay errores
set -e

#Ir a la raíz del proyecto
cd "$(dirname "$0")/.."

echo "🧪 [TEST] Iniciando GoogleTest..."

# 1. Limpieza de la carpeta de tests
if [ -d "build_tests" ]; then
    echo "🧹 Limpiando build de tests anterior..."
    rm -rf build_tests
fi
mkdir build_tests
cd build_tests

# 2. Configuración CMake (Nativo, SIN toolchain ARM)
echo "⚙️  Configurando entorno de pruebas..."
cmake -G Ninja \
    -DBUILD_MODE=TEST \
    ..

# 3. Compilar y Ejecutar
echo "🏗️  Compilando Tests..."
ninja

echo "🏃 Ejecutando Tests..."
ctest --output-on-failure --verbose

echo "✅ [EXITO] Todos los tests pasaron."