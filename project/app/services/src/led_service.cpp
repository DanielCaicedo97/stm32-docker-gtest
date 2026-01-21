#include "led_service.h"
// Solo incluimos el hardware si estamos compilando para el micro
#ifdef USE_HAL_DRIVER
    #include "gpio.h"  
    #include "main.h"
#endif

// Constructor
LedService::LedService(Port port, uint8_t pin) {
    _port = port;
    _pin = pin;
    _state = false;
}

void LedService::on() {
    hardwareWrite(true);
}

void LedService::off() {
    hardwareWrite(false);
}

void LedService::toggle() {
    hardwareWrite(!_state);
}

bool LedService::getState() {
    return _state;
}

void LedService::hardwareWrite(bool level) {
    _state = level;

#ifdef USE_HAL_DRIVER
    // 1. Declaramos las variables AQUÍ (Locales a esta función)
    GPIO_TypeDef* GPIOx = nullptr;

    // 2. Traducimos el Enum al puntero de registro AHORA
    switch (_port) {
        case PORT_A: GPIOx = GPIOA; break;
        case PORT_B: GPIOx = GPIOB; break;
        case PORT_C: GPIOx = GPIOC; break;
        default: return; 
    }

    // 3. Calculamos la máscara del pin AHORA
    uint16_t GPIO_Pin = (1 << _pin);

    // 4. Escribimos al hardware (Verificamos que el puerto sea válido)
    if (GPIOx != nullptr) {
        HAL_GPIO_WritePin(GPIOx, GPIO_Pin, level ? GPIO_PIN_RESET : GPIO_PIN_SET);
    }
#endif
}