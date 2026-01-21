# project/app/CMakeLists.txt

message(STATUS "🔍 Escaneando App para autoconfiguración...")

add_library(app_lib INTERFACE) # agregado para tipo interface 

# 1. Encontrar todos los fuentes (.c/.cpp) y cabeceras (.h) recursivamente
file(GLOB_RECURSE APP_SOURCES 
    "${CMAKE_CURRENT_LIST_DIR}/*.c" 
    "${CMAKE_CURRENT_LIST_DIR}/*.cpp"
)
file(GLOB_RECURSE APP_HEADERS "${CMAKE_CURRENT_LIST_DIR}/*.h")

# Validación de seguridad
if(NOT APP_SOURCES)
    message(FATAL_ERROR "❌ ERROR: Carpeta 'app' vacía. Agrega tu lógica de negocio.")
endif()

# 2. Crear la librería
#add_library(app_lib STATIC ${APP_SOURCES} ${APP_HEADERS})
target_sources(app_lib INTERFACE ${APP_SOURCES})  # agregado para tipo interface
# ==============================================================================
#  AUTO-DISCOVERY DE INCLUDES
# ==============================================================================
set(AUTO_INCLUDE_DIRS "")

# Recorremos cada archivo .h encontrado
foreach(_headerFile ${APP_HEADERS})
    # Extraemos solo la ruta de la carpeta (quitamos el nombre del archivo)
    get_filename_component(_dir "${_headerFile}" DIRECTORY)
    # Lo agregamos a una lista temporal
    list(APPEND AUTO_INCLUDE_DIRS "${_dir}")
endforeach()

# Limpiamos la lista: Si una carpeta tiene 10 archivos .h, aparecerá 10 veces.
# Esto deja solo una entrada por carpeta.
if(AUTO_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES AUTO_INCLUDE_DIRS)
endif()

# Mostramos qué carpetas encontró (para depurar)
message(STATUS "📂 Carpetas de Include detectadas:")
foreach(_dir ${AUTO_INCLUDE_DIRS})
    message(STATUS "   -> ${_dir}")
endforeach()

# Aplicamos los directorios a la librería
#target_include_directories(app_lib PUBLIC ${AUTO_INCLUDE_DIRS})
target_include_directories(app_lib INTERFACE ${AUTO_INCLUDE_DIRS})  # agregado para tipo interface


message(STATUS "✅ Target 'app_lib' configurado. Listo para ser linkeado.")