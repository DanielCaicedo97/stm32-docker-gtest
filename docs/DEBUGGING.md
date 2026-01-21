# 🐞 Guía de Configuración para Debugging (STM32 + Docker + VS Code)

Esta guía explica cómo configurar Visual Studio Code en Windows para depurar el firmware compilado dentro de Docker, utilizando las herramientas nativas de **STM32CubeIDE** sin instalar nada extra.

## 📋 Requisitos Previos

1.  **VS Code Extension:** Instalar la extensión [Cortex-Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug).
2.  **STM32CubeIDE:** Tener instalado el IDE oficial de ST (contiene los drivers y servidores GDB).
3.  **Hardware:** ST-Link V2 conectado a la BluePill y al PC.

---

## ⚙️ Paso 1: Localizar las Rutas de ST (¡Importante!)

Las herramientas de ST cambian de carpeta con cada versión. Antes de configurar, busca estas 3 rutas en tu PC (generalmente en `C:\ST\STM32CubeIDE_x.x.x`):

1.  **ST-LINK GDB Server:**
    * Busca el archivo: `ST-LINK_gdbserver.exe`
    * *Ruta típica:* `.../plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.../tools/bin/ST-LINK_gdbserver.exe`
2.  **ARM GDB (Toolchain):**
    * Busca el archivo: `arm-none-eabi-gdb.exe`
    * *Necesitamos la CARPETA:* `.../plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools.../tools/bin`
3.  **CubeProgrammer CLI:**
    * Busca el archivo: `STM32_Programmer_CLI.exe`
    * *Necesitamos la CARPETA:* `.../plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.../tools/bin`

---

## 🚀 Paso 2: Configurar `launch.json`

Crea o edita el archivo `.vscode/launch.json` en la raíz de tu proyecto y pega la siguiente configuración.

**⚠️ ATENCIÓN:** Debes reemplazar las rutas de ejemplo con las que encontraste en el Paso 1.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "🐛 Debug STM32 (Docker + ST Tools)",
            "cwd": "${workspaceFolder}",
            // Ruta al archivo compilado (generado por Docker)
            "executable": "${workspaceFolder}/project/build_mcu/firmware_stm32f103c8t6/firmware_stm32f103c8t6.elf",
            "request": "launch",
            "type": "cortex-debug",
            "runToEntryPoint": "main",
            
            // Configuración del Hardware
            "servertype": "stlink",
            "device": "STM32F103C8",
            "interface": "swd",
            "serialNumber": "", 

            // =================================================================
            // 🛠️ RUTAS DE HERRAMIENTAS (AJUSTAR SEGÚN TU INSTALACIÓN)
            // =================================================================
            
            // 1. Ruta completa al ejecutable del servidor GDB
            "serverpath": "C:/ST/STM32CubeIDE_2.0.0/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.stlink-gdb-server.win32_2.2.300.202509021040/tools/bin/ST-LINK_gdbserver.exe",

            // 2. Ruta a la CARPETA donde está arm-none-eabi-gdb.exe
            "armToolchainPath": "C:/ST/STM32CubeIDE_2.0.0/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.13.3.rel1.win32_1.0.100.202509120712/tools/bin",

            // 3. Ruta a la CARPETA donde está STM32_Programmer_CLI.exe
            // (Vital para que no se cierre el debugger inesperadamente)
            "stm32cubeprogrammer": "C:/ST/STM32CubeIDE_2.0.0/STM32CubeIDE/plugins/com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.win32_2.2.300.202508131133/tools/bin",

            // =================================================================
            
            "showDevDebugOutput": "none",

            // Esto le dice a VS Code que los archivos que Docker ve en /home/project
            // en realidad están en la carpeta 'project' de este workspace.
            "overrideLaunchCommands": [
                "-gdb-set substitute-path /home/project C:/your/path/here/project"
                ]
        }
    ]
}