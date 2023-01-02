#include <stdio.h>
#include <stdbool.h>
#include <platform.h>
#include "gpio_init.h"

volatile struct Traffic_Light TLStreetA, TLStreetB;
volatile int traffic_Timer;

struct Traffic_Light {
    int current_State;
    int current_Colour;
    int current_Region;
    bool traffic_Sensor;
};

XStatus initGpio(void);
int setUpInterruptSystem();
void hwTimerISR(void *CallbackRef);
int trafficTimer(int current_State);
int trafficLightStateA(int start_State, int timer, int traffic_Sensor, struct Traffic_Light *TL);
int trafficLightStateB(int start_State, int timer, int traffic_Sensor, struct Traffic_Light *TL);
int trafficSensor(int slideSwitchIn);

void main()  
{
    init_platform();

        int traffic_Sensor;
        int slideSwitchIn;
        int status;

    	status = initGpio();
    	if (status != XST_SUCCESS) {
    		print("GPIOs initialization failed! \n\r");
    		cleanup_platform();
    		return 0;
    	}

    	status = setUpInterruptSystem();
    	if (status != XST_SUCCESS) {
    		print("Interrupt system setup failed!\n\r");
    		cleanup_platform();
    		return 0;
    	}

        while(1) {
            slideSwitchIn = XGpio_DiscreteRead(&SLIDE_SWITCHES, 1);
            traffic_Sensor = trafficSensor(slideSwitchIn);

            // Sequential logic - current state = next state;
            TLStreetA.current_State = trafficLightStateA(0, traffic_Timer, traffic_Sensor, &TLStreetA);
            TLStreetB.current_State = trafficLightStateB(4, traffic_Timer, traffic_Sensor, &TLStreetB);

        }

    cleanup_platform();
    return;
}

void hwTimerISR(void *CallbackRef) 
{
    static int i = 0;
    i = (i == 1) ? 0 : 1;
    traffic_Timer = trafficTimer(TLStreetA.current_State);
    if(i == 0) {
        XGpio_DiscreteWrite(&VGA_COLOUR, 1, TLStreetA.current_Colour);
        XGpio_DiscreteWrite(&VGA_REGION, 1, TLStreetA.current_Region);
    }
    else {
        XGpio_DiscreteWrite(&VGA_COLOUR, 1, TLStreetA.current_Colour);
        XGpio_DiscreteWrite(&VGA_REGION, 1, TLStreetA.current_Region);
    }
}

int trafficTimer(int current_State)
{
    int timer = 0, timerA = 2, timerB = 2, timerC = 2;
    static int timer_a = 0, timer_b = 0, timer_c = 0;
    if(current_State == 0 && current_State == 4) {
        timer = (timer_a <= timerA*250) ? timer_a++ : 0;
        timer_a = (timer_a == timerA*250) ? 0 : timer_a;
    }
    else if(current_State == 2 && current_State == 6) {
        timer = (timer_b <= timerB*250) ? timer_b++ : 0;
        timer_b = (timer_b == timerB*250) ? 0 : timer_b;
    }
    else if(current_State == 3 && current_State == 7) {
        timer = (timer_c <= timerC*250) ? timer_c++ : 0;
        timer_c = (timer_c == timerC*250) ? 0 : timer_c;
    }
    else{
        timer = 0;
    }
    return timer;
}

int trafficLightStateA(int start_State, int timer, int traffic_Sensor, struct Traffic_Light *TL) 
{
    static int next_State;
    int timerA = 2*250, timerB = 2*250, timerC = 2*250;
    switch(next_State) {
        // GREEN COLOUR
        case 0 :
            next_State = (timer == timerA) ? 1 : 0;
            (*TL).current_Colour = 0x0F0;
            (*TL).current_Region = 0b000000001;
            break;
        // GREEN LOOP COLOUR
        case 1 :
            next_State = (traffic_Sensor == 2 || traffic_Sensor == 3) ? 2 : 1;
            (*TL).current_Colour = 0x0F0;
            (*TL).current_Region = 0b000000001;
            break;
        // YELLOW TRANSITION COLOUR
        case 2 :
            next_State = (timer == timerB) ? 3 : 2;
            (*TL).current_Colour = 0xFF0;
            (*TL).current_Region = 0b010000000;
            break;
        // RED TRANSITION COLOUR
        case 3 :
            next_State = (timer == timerC) ? 4 : 3;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b001000000;
            break;
        // RED COLOUR
        case 4 :
            next_State = (timer == timerA) ? 5 : 4;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b001000000;
            break;
        // RED LOOP COLOUR
        case 5 :
            next_State = (traffic_Sensor == 1 || traffic_Sensor == 3) ? 6 : 5;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b001000000;
            break;
        // RED TRANSITION COLOUR
        case 6 :
            next_State = (timer == timerB) ? 7 : 6;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b001000000;
            break;
        // YELLOW TRANSITION COLOUR
        case 7 :
            next_State = (timer == timerC) ? 0 : 7;
            (*TL).current_Colour = 0xFF0;
            (*TL).current_Region = 0b010000000;
            break;
        default :
            next_State = start_State;
    }
    return next_State;
}

int trafficLightStateB(int start_State, int timer, int traffic_Sensor, struct Traffic_Light *TL) 
{
    static int next_State;
    int timerA = 2, timerB = 2, timerC = 2;
    switch(next_State) {
        // GREEN COLOUR
        case 0 :
            next_State = (timer == timerA) ? 1 : 0;
            (*TL).current_Colour = 0x0F0;
            (*TL).current_Region = 0b000000010;
            break;
        // GREEN LOOP COLOUR
        case 1 :
            next_State = (traffic_Sensor == 2 || traffic_Sensor == 3) ? 2 : 1;
            (*TL).current_Colour = 0x0F0;
            (*TL).current_Region = 0b000000010;
            break;
        // YELLOW TRANSITION COLOUR
        case 2 :
            next_State = (timer == timerB) ? 3 : 2;
            (*TL).current_Colour = 0xFF0;
            (*TL).current_Region = 0b100000000;
            break;
        // RED TRANSITION COLOUR
        case 3 :
            next_State = (timer == timerC) ? 4 : 3;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b000000010;
            break;
        // RED COLOUR
        case 4 :
            next_State = (timer == timerA) ? 5 : 4;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b000100000;
            break;
        // RED LOOP COLOUR
        case 5 :
            next_State = (traffic_Sensor == 1 || traffic_Sensor == 3) ? 6 : 5;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b000100000;
            break;
        // RED TRANSITION COLOUR
        case 6 :
            next_State = (timer == timerB) ? 7 : 6;
            (*TL).current_Colour = 0xF00;
            (*TL).current_Region = 0b000100000;
            break;
        // YELLOW TRANSITION COLOUR
        case 7 :
            next_State = (timer == timerC) ? 0 : 7;
            (*TL).current_Colour = 0xFF0;
            (*TL).current_Region = 0b100000000;
            break;
        default :
            next_State = start_State;
    }
    return next_State;
}

int trafficSensor(int slideSwitchIn)
{
    int traffic_Sensor;
    // street A sensor = 0x0001, street B sensor = 0x0002
    if(slideSwitchIn != 0) {
        traffic_Sensor = (slideSwitchIn == 0x0001) ? 1 : ((slideSwitchIn == 0x0002) ? 2 : ((slideSwitchIn == 0x0003) ? 3 : 0));
    }
    return traffic_Sensor;
}