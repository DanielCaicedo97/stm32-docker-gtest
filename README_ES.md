<div align="center">
  <img src="./images/logo_dani_Dev.svg" alt="Logo del Proyecto" width="120">
  <h1>STM32 Firmware Build System</h1>
  <p>
    <strong>Entorno de desarrollo contenerizado para sistemas embebidos</strong>
  </p>
  
  <p>
    <img src="https://img.shields.io/badge/C%2B%2B-17-blue?logo=c%2B%2B" alt="C++">
    <img src="https://img.shields.io/badge/C-Standard-blue?logo=c" alt="C">
    <img src="https://img.shields.io/badge/STM32-Embedded-green?logo=stmicroelectronics" alt="STM32">
    <img src="https://img.shields.io/badge/Docker-Container-2496ED?logo=docker" alt="Docker">
    <img src="https://img.shields.io/badge/Tests-GTest-brightgreen?logo=google" alt="GTest">
    <img src="https://img.shields.io/badge/Build-CMake_%26_Ninja-orange?logo=cmake" alt="CMake">
    <img src="https://img.shields.io/badge/Hecho_en-Colombia_🇨🇴-FCD116?labelColor=003893" alt="Hecho en Colombia">
  </p>
</div>

---

## 📖 Descripción
Este repositorio contiene la infraestructura y el código fuente para el firmware del proyecto. Todo el entorno de compilación, pruebas y generación de binarios está **dockerizado**, garantizando que todos los desarrolladores utilicen las mismas versiones de compiladores y herramientas (Toolchains).

### 🛠️ Tecnologías Usadas
* **Lenguajes:** C / C++
* **Build System:** CMake + Ninja
* **Testing:** GoogleTest (GTest)
* **Hardware Target:** Familia STM32 (Default: `stm32f103c8t6`)

---

## 🐳 Guía Rápida (Docker Workflow)

### 1. Construir la Imagen (Build)
Antes de empezar, asegúrate de estar en la raíz donde se encuentra el `docker-compose.yml`.

```bash
docker-compose build
```

### 2. Ejecutar Tests y Compilación (Host)
Este comando levanta el contenedor, compila el proyecto y ejecuta los tests unitarios en el entorno simulado.

Uso: Desarrollo diario, pruebas lógicas.

Comando manual:

``` bash
 docker-compose run --rm builder bash scripts/start_testing.bash
 ```
### 3. Cambiar el Modelo del Chip (Target)
Puedes inyectar la variable CHIP para cambiar la configuración de compilación dinámicamente.

``` bash
 docker-compose run --rm builder bash scripts/start_building.bash stm32f103c8t6
```
### 4. Generar Binario para MCU (Cross-Compilation)
Para generar el archivo .elf, .bin o .hex que irá al microcontrolador, utilizamos el toolchain de ARM dentro de Docker.

``` bash
 docker-compose run --rm builder bash scripts/start_testing.bash stm32f103c8t6 ../cmake-toolchain/arm-toolchain.cmake
```

## ⚡ Uso de Scripts (Resumen)

Para simplificar el flujo de trabajo, utilizamos scripts predefinidos en la carpeta `/scripts`.

| Acción | Comando | Descripción |
| :--- | :--- | :--- |
| **Correr Tests** | `docker-compose run --rm builder bash scripts/start_testing.bash` | Ejecuta tests con config por defecto. |
| **Compilar MCU** | `docker-compose run --rm builder bash scripts/start_building.bash stm32f103c8t6` | Compila el firmware para el chip especificado. |
| **Tests + Chip** | `docker-compose run --rm builder bash scripts/start_testing.bash stm32f103c8t6` | Ejecuta tests simulando el chip específico. |



## 🐞 Debugging y Configuración de IDE

¿Necesitas depurar el código paso a paso en el hardware real usando Visual Studio Code y ST-Link?

Hemos preparado una guía detallada para configurar tu entorno local (Windows/Linux) y conectarlo con los binarios generados por Docker.

> 👉 **[Hacer Clic aquí para ver la Guía de Debugging (VS Code + STM32)](docs/DEBUGGING.md)**

## 🆕 Cómo agregar un nuevo Chip (Scaling)

Si deseas trabajar con un modelo de microcontrolador diferente, sigue estos pasos para integrarlo al sistema de construcción sin errores:

1.  **Generar Proyecto Base:** Crea tu proyecto STM32 (usando STM32CubeMX o STM32CubeIDE) asegurándote de seleccionar **CMake** como el "Toolchain/IDE Project Structure".
2.  **Estructura de Carpetas:** Crea una carpeta nueva en la raíz del proyecto siguiendo estrictamente esta convención de nombres:
    `firmware_<nombre_del_chip>` (Ejemplo: `firmware_stm32f401ccu6`).
3.  **Configuración de CMake:**
    * Dirígete a la carpeta `templates/` de este repositorio.
    * Consulta el archivo `CMakeList_template_firmware.txt`.
    * Usa este archivo como base para el `CMakeLists.txt` de tu nuevo chip. Esto es crucial para mantener la compatibilidad con las variables de entorno de Docker y las rutas de compilación.