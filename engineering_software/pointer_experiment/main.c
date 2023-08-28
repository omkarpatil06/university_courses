#include <stdio.h>
#include "platform.h"
#include "xil_types.h"		// Added for integer type definitions
#include "seg7_display.h"
#include "gpio_init.h" // Added for 7-segment definitions

#define MAX 10

void sort(u16 *);
void swap(u16 *, u16 *);
void xil_printf(const char *ctrl1, ...);

int main() {
	init_platform();
	
	int i = 0;
	int status;
	int array[MAX - 1];
	u16 slideSwitchIn;
	u16 pushBtnLeftIn = 0;
	u16 pushBtnRigthIn = 0;

    // Initialise the GPIOs
    status = initGpio();
	if (status != XST_SUCCESS) {
		print("GPIOs initialization failed!\n\r");
		cleanup_platform();
		return 0;
	}
	// Setup the Interrupt System
	status = setUpInterruptSystem();
	if (status != XST_SUCCESS) {
		print("Interrupt system setup failed!\n\r");
		cleanup_platform();
		return 0;
	}

	while(i < MAX) {					// i can take values from 0 - 9
		displayNumber(i);
		pushBtnRigthIn = XGpio_DiscreteRead(&P_BTN_RIGHT, 1);
		slideSwitchIn = XGpio_DiscreteRead(&SLIDE_SWITCHES, 1);

		if(pushBtnRigthIn == 1) {
			while(pushBtnRigthIn == 1) {
				pushBtnRigthIn = XGpio_DiscreteRead(&P_BTN_RIGHT, 1);
			}
			*(array + i) = slideSwitchIn;
			i++;
		}
	}

	i = 0;
	array = sort(array);
	while(1) {
		displayNumber(*(array + i));
		pushBtnLeftIn = XGpio_DiscreteRead(&P_BTN_LEFT, 1);
		if (pushBtnLeftIn == 1) {
			while (pushBtnLeftIn == 1) {
				pushBtnLeftIn = XGpio_DiscreteRead(&P_BTN_LEFT, 1);
			}
			if (i < MAX - 1) {
				i = i + 1;
			}
			else {
				i = 0;
			}
		}
	}
	}

    cleanup_platform();
    return 0;
}

void sort(u16 *array_ptr){
	int i = 0, j = 0;
	for (i = 0; i < MAX; i++){
		for (j = 1; j < MAX; j++){
			if (*(array_ptr + j) < *(array_ptr + j - 1)){
				swap(array_ptr + j, array_ptr + j - 1);
			}
		}
	}
}

void swap(u16 *a_ptr, u16 *b_ptr) {
	*a_ptr = *a_ptr + *b_ptr;
	*b_ptr = *a_ptr - *b_ptr;
	*a_ptr = *a_ptr - *b_ptr;
}
