
#ifndef GPIO_INIT_H_
#define GPIO_INIT_H_

#include "xgpio.h"		// Required for initialising hardware devices.

XStatus initGpio(void);

XGpio SLIDE_SWITCHES;
XGpio VGA_COLOUR;
XGpio VGA_REGION;

#endif /* GPIO_INIT_H_ */
