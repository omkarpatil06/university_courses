  /******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE. 
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "gpio_init.h"

XStatus initGpio(void);
int setUpInterruptSystem();

volatile u16 sel_region;		//Allows to select region of code.
volatile u8 counter = 0;		//Allows to delay transition of region every 0.2s.
volatile u8 i = 0;				//Allows to display patterns of regions.
volatile int garr[] = {0, 3, 2, 1, 8, 7, 6, 5, 4, 9};
volatile int oarr[] = {0, 3, 2, 1, 8, 7, 6, 5, 4, 3};
volatile u8 arraySelect = 0;

int main() {
    init_platform();		// Start of code

    u16 slideSwitchIn = 0;		//Allows to store which slide switch is selected.
    u16 region = 0;
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

    	slideSwitchIn = XGpio_DiscreteRead(&SLIDE_SWITCHES, 1);		//Stores which slide switch is selected.

    	XGpio_DiscreteWrite(&VGA_COLOUR, 1, slideSwitchIn);			//Sets colour displayed based on slide switch info.

    	arraySelect = slideSwitchIn >> 12;

    	switch (sel_region) {
    		case 0:
    			region = 0b000000000;
    			break;
    		case 1:
    			region = 0b000000001;
    			break;
    		case 2:
    			region = 0b000000010;
    			break;
    		case 3:
    			region = 0b000000100;
    			break;
    		case 4:
    			region = 0b000001000;
    			break;
    		case 5:
    			region = 0b000010000;
    			break;
    		case 6:
    			region = 0b000100000;
    			break;
    		case 7:
    			region = 0b001000000;
    			break;
    		case 8:
    			region = 0b010000000;
    			break;
    		case 9:
    			region = 0b100000000;
    			break;
    		default:
    			break;
    	}

    	XGpio_DiscreteWrite(&VGA_REGION, 1, region);		// Sets the region to display colour.
    }

    cleanup_platform();		// End of code
    return 0;
}

void hwTimerISR(void *CallbackRef) {
	counter = counter + 1;
	if (counter == 2) {
		if (arraySelect == 0x0001) {
			i = i < 10 ? i + 1 : 0;
			sel_region = garr[i];
		}
		else {
			i = i < 10 ? i + 1 : 0;
			sel_region = oarr[i];
		}
		counter = 0;
	}
	else {
		sel_region = 0;
	}
}
