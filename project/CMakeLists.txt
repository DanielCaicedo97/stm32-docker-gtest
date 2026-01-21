cmake_minimum_required(VERSION 3.22)

# Inicialmente solo C y ASM para el Firmware.
# C++ se activa solo si entramos en modo TEST.
project(Guajira_STM32_secure_node LANGUAGES C ASM CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Activamos C++ 
enable_language(CXX)

# ==============================================================================
# 1. DEFINICIÓN DE VARIABLE (Esto elimina el Warning)
# ==============================================================================
# Al definir esto como CACHE STRING, CMake reconoce la bandera -DBUILD_MODE
set(BUILD_MODE "FIRMWARE" CACHE STRING "Select build mode: FIRMWARE or TEST")
message(STATUS "🚦 MODO DE CONSTRUCCIÓN ACTUAL: ${BUILD_MODE}")

# ==============================================================================
# 2. LIBRERÍA Y LOGICA DE NEGOCIO
# ==============================================================================
add_subdirectory(app)
# ==============================================================================
# 3. LÓGICA DEL SEMÁFORO
# ==============================================================================

if(BUILD_MODE STREQUAL "TEST")
    # --------------------------------------------------------
    # 🧪 MODO TEST (GoogleTest en PC)
    # --------------------------------------------------------
    message(STATUS "💻 Configurando entorno para PRUEBAS UNITARIAS (Host)...")
    # Descargar GoogleTest
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.14.0
    )
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
    enable_testing()
    # Agregamos la carpeta de tests
    add_subdirectory(test)
   
else()
    # --------------------------------------------------------
    # 🤖 MODO FIRMWARE (STM32 en ARM)
    # --------------------------------------------------------
    message(STATUS "🔧 Configurando entorno para FIRMWARE STM32 (ARM)...")
    # --- VALIDACIÓN DEL TOOLCHAIN (Lo que pediste) ---
    if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
        message(FATAL_ERROR "❌ ERROR CRÍTICO: Estás en modo FIRMWARE pero no has cargado el Toolchain de ARM.\n"
                            "   Asegúrate de ejecutar CMake con: -DCMAKE_TOOLCHAIN_FILE=Path/to/arm-toolchain.cmake")
    else()
        message(STATUS "✅ Toolchain detectado: ${CMAKE_TOOLCHAIN_FILE}")
    endif()

    # Gestión dinámica del Chip
    set(CHIP "stm32f103c8t6" CACHE STRING "Target Chip")
    set(FIRMWARE_DIR "./firmware_${CHIP}")

    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${FIRMWARE_DIR}")
        add_subdirectory(${FIRMWARE_DIR})
    else()
        message(FATAL_ERROR "❌ No existe la carpeta del firmware: ${FIRMWARE_DIR}")
    endif()

endif()