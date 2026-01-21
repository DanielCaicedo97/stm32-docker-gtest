#pragma once
#include <cstdint>

class LedService {
public:
    // Definimos el Enum para facilitar la vida
    enum Port { PORT_A, PORT_B, PORT_C, PORT_D};

    LedService(Port port, uint8_t pin);
    
    void toggle();
    void on();
    void off();
    bool getState();

private:
    Port _port;
    uint8_t _pin;
    bool _state;
    void hardwareWrite(bool level);
};