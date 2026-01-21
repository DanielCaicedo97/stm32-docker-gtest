#include <gtest/gtest.h>
#include "led_service.h"

// Test de Inicialización
TEST(LedServiceTest, InitialStateIsOff) {
    // Usamos el enum correcto: LedService::PORT_C
    LedService led(LedService::PORT_C, 13);
    
    // Verificamos que al crear el objeto, el estado sea false (apagado)
    EXPECT_FALSE(led.getState());
}

// Test de Encendido
TEST(LedServiceTest, TurnOnUpdatesState) {
    LedService led(LedService::PORT_A, 5);
    
    led.on();
    
    // El estado interno debe cambiar a true
    EXPECT_TRUE(led.getState());
}

// Test de Toggle (Alternar)
TEST(LedServiceTest, ToggleFunctionality) {
    LedService led(LedService::PORT_B, 2);
    
    // De Off a On
    led.toggle();
    EXPECT_TRUE(led.getState());
    
    // De On a Off
    led.toggle();
    EXPECT_FALSE(led.getState());
}