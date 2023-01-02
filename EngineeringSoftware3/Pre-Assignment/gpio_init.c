
#include "gpio_init.h"		//Include gpio_init header file.

XStatus initGpio(void) {
	XStatus status;

	// Initialising the slide switches. Device ID is 7.
	status = XGpio_Initialize(&SLIDE_SWITCHES, 7);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Initialising the colour output through VGA. Device ID is 8.
	status = XGpio_Initialize(&VGA_COLOUR, 8);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Initialising the region output through VGA Device ID is 10.
	status = XGpio_Initialize(&VGA_REGION, 10);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}
}
