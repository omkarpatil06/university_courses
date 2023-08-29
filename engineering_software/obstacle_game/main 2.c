/*
Dodge Box is a multi-player game, with the main aim of dodging as many randomly generated obstacles.
Follow these steps to play the game:
	1)	Switch the left-most slide switch (0x8000) to turn the game ON. DO NOT SWITCH BACK!
	2)	Player 1 commences the game by pressing the LEFT push button.
	3)	To dodge the obstacles, Player 1 should press the UP or DOWN push button.
	4)	To change levels, switch any of the 5 right-most slide switches (read about levels in IV).
	5)	After unsuccessfully dodging an obstacle, the game is over for Player 1.
	6)	Player 2 starts their game by pressing the RIGHT push button.
	7)	To dodge the obstacles, Player 2 should press the UP or DOWN push button.
	8)	To change levels, switch any of the 5 right-most slide switches (read about levels in IV).
	9)	After unsuccessfully dodging an obstacle, the game is over for Player 2.
	10)	The player with the most number of points win, indicated by the side on which the LEDs blink.
	11)	Click the CENTRE push button to play again.
Author: Omkar Patil, Troy Pinkney and Fatin Roslan.
Version 1.0
*/

#include <stdio.h>
#include <stdlib.h>
#include "platform.h"
#include "xil_types.h"
#include "seg7_display.h"
#include "gpio_init.h"
#include "xgpio.h"		// Required for initialising hardware devices.

// A structure for storing obstacle region data.
struct Obstacle {
	int startRegion;
	int currentRegion;
};

// A structure for storing players box region and score data.
struct Object {
	int highScore1;
	int highScore2;
	int pointScored;
	int currentRegion;
	int currentColour;
};

// Declaring all functions used in main and timer.
XStatus initGpio(void);
int setUpInterruptSystem();
void hwTimerISR(void *CallbackRef);
void xil_printf(const char *ctrl1, ...);

void Generator();
void GarbageCollection();
void RedemptionLED();
void Obstacle1(struct Object *Player, struct Obstacle *O);
void Obstacle2(struct Object *Player, struct Obstacle *O);
void Obstacle3(struct Object *Player, struct Obstacle *O);
void EndGame(struct Object *Player, struct Obstacle *Obs1, struct Obstacle *Obs2, struct Obstacle *Obs3);

// Declaring all volatile structures and variables.
volatile struct Object Player;
volatile struct Obstacle Obs1, Obs2, Obs3;

volatile u8 i = 0;
volatile u16 ledValue;
volatile int j = 0, flash_timer = 0;
volatile int slideSwitchIn, pushBtnRight;
volatile int statusObs1, statusObs2, statusObs3;
volatile u16 movement_speed = 5, spawn_speed = 5;
volatile int gen_timer = 0, timer_a = 0, timer_b = 0, timer_c = 0;

int main() {
    init_platform();

    // Declaring all local variables.
    int status, pushBtnLeft;

    // Initial initialisation of variables.
    Player.highScore1 = 0;	// Put 1 to record high score after reset
    Player.highScore2 = 0;	// Put 1 to record high score after reset
	Player.pointScored = 0;
	Player.currentRegion = 0;
	Player.currentColour = 0xFF0;
	Obs1.startRegion = 9;
	Obs2.startRegion = 10;
	Obs3.startRegion = 11;
	Obs1.currentRegion = 12;
	Obs2.currentRegion = 12;
	Obs3.currentRegion = 12;


	// Set up all hardware devices.
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

	/* Checks if slide switch and push button is pressed.
	 * If any of the conditions are met, the value of i is set to specified value and game starts.
	 * The leftmost slide switch STARTS the game.
	 * Variable i dictates starting player. i = 1 : Player 1 starts.
	 */
	while(i == 0) {
		// Checking for hardware devices.
		slideSwitchIn = XGpio_DiscreteRead(&SLIDE_SWITCHES, 1);
		pushBtnLeft = XGpio_DiscreteRead(&P_BTN_LEFT,1);

		// Setting the value of i if hardware devices are active.
		i = ((slideSwitchIn >= 0x8000) && (pushBtnLeft == 1)) ? 1 : i;
	}

	/* Does a series of steps in the while loop, for proper execution of hwTimerISR.
	 *Step 1: Checking if UP and DOWN button, to move player box.
	 *Step 2: Checking if any of the right most slide switches are switched, to set level.
	 *Step 3: Checking if obstacles has collided with player box.
	 *Step 4: Setting the high score of current player constantly.
	 */
	while(1) {
		// Displaying number of points scored.
		displayNumber(Player.pointScored);

		// Checking if up button is pressed and moves player down.
		if(XGpio_DiscreteRead(&P_BTN_UP,1)) {
			while(XGpio_DiscreteRead(&P_BTN_UP,1));
			if(Player.currentRegion == 2 || Player.currentRegion == 1) {
				// Decrementing by unity makes player goes to the region above.
				Player.currentRegion--;
			}
		}

		// Checking if down button is pressed and moves player down.
		if(XGpio_DiscreteRead(&P_BTN_DOWN,1)){
			while(XGpio_DiscreteRead(&P_BTN_DOWN,1));
			if(Player.currentRegion == 0 || Player.currentRegion == 1) {
				// Incrementing by unity makes player goes to the region bellow.
				Player.currentRegion++;
			}
		}

		// Checking if slide switches are switched to set level -> spawn and movement speed.
		slideSwitchIn = XGpio_DiscreteRead(&SLIDE_SWITCHES, 1);
		switch(slideSwitchIn) {
		// The right most slide switch is LEVEL 1.
			case 0x8001:
				spawn_speed = 5;
				movement_speed = 5;
				break;
			// The second to right most slide switch is LEVEL 2
			case 0x8002:
				spawn_speed = 4;
				movement_speed = 4;
				break;
			// The third to right most slide switch is LEVEL 3.
			case 0x8004:
				spawn_speed = 3;
				movement_speed = 3;
				break;
			// The fourth to right most slide switch is LEVEL 4.
			case 0x8008:
				spawn_speed = 2;
				movement_speed = 2;
				break;
			// The fifth to right most slide switch is LEVEL 5.
			case 0x8010:
				spawn_speed = 1;
				movement_speed = 1;
				break;
			default:
				spawn_speed = 5;
				movement_speed = 5;
				break;
		}

		/* If any of the three obstacles (representing an obstacle from each of the rows), has collided with player.
		 * i = 3 : Player 1 end screen.
		 * i = 4 : Player 2 end screen.
		 */
		if(Player.currentRegion == Obs1.currentRegion || Player.currentRegion == Obs2.currentRegion || Player.currentRegion == Obs3.currentRegion) {
			Player.currentColour = 0xF00;
			// Sets i to 3 or 4. Indicates a buffer state for second player to press push button to begin.
			if(i == 4)
				i = 4;
			else
				i = (i == 2) ? 4 : 3;
		}

		// Making current point of player 1 or 2, the current high score.
		Player.highScore1 = (i == 1) ? Player.pointScored : Player.highScore1;
		Player.highScore2 = (i == 2) ? Player.pointScored : Player.highScore2;

		xil_printf("%d	%d	%d\n",Obs1.currentRegion, Obs2.currentRegion, Obs3.currentRegion);
	}
    cleanup_platform();
    return 0;
}

void hwTimerISR(void *CallbackRef) {
	// Used to display an individual digit of a segment at refresh rate.
	displayDigit();

	/* If i == 1 (player 1 is playing -> LED on left) and i == 2 (player 2 is playing-> LED on right).
	 * The if statement performs a series of steps. These are:
	 * Step 1: Move the player UP or DOWN based on command from while(1) loop in main.
	 * Step 2: void Generator() function  is called -> random number generator (RNG) makes an obstacle move.
	 * Step 3: Moves any of the 3, or combination of 3 obstacles if selected by RNG.
	 */
	if(i == 1 || i == 2) {
		// LED displays which user is playing.
		if(i == 1)
			XGpio_DiscreteWrite(&LED_OUT,1,0xFF00);
		else if(i == 2)
			XGpio_DiscreteWrite(&LED_OUT,1,0x00FF);

		// The RNG requests an obstacle to move from any of the 3 rows.
		Generator();

		// Move the current region of user based on command from main.
		switch(Player.currentRegion) {
		// Colours REGION 0 and sets off REGION 1 and 2.
		case 0 :
			XGpio_DiscreteWrite(&REGION_0_COLOUR,1,Player.currentColour);
			XGpio_DiscreteWrite(&REGION_1_COLOUR,1,0xFFF);
			XGpio_DiscreteWrite(&REGION_2_COLOUR,1,0xFFF);
			break;
		// Colours REGION 1 and sets off REGION 0 and 2.
		case 1 :
			XGpio_DiscreteWrite(&REGION_1_COLOUR,1,Player.currentColour);
			XGpio_DiscreteWrite(&REGION_0_COLOUR,1,0xFFF);
			XGpio_DiscreteWrite(&REGION_2_COLOUR,1,0xFFF);
			break;
		// Colours REGION 2 and sets off REGION 0 and 1.
		case 2 :
			XGpio_DiscreteWrite(&REGION_2_COLOUR,1,Player.currentColour);
			XGpio_DiscreteWrite(&REGION_0_COLOUR,1,0xFFF);
			XGpio_DiscreteWrite(&REGION_1_COLOUR,1,0xFFF);
			break;
		}

		// Moves the current region of obstacle 1 (row 1 obstacle) to move left, if called by RNG.
		Obstacle1(&Player, &Obs1);
		switch(Obs1.currentRegion) {
		// Colours REGION 9.
		case 9 :
			XGpio_DiscreteWrite(&REGION_9_COLOUR,1,0x0F0);
			break;
		// Colours REGION 6 and sets off REGION 9.
		case 6 :
			XGpio_DiscreteWrite(&REGION_6_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_9_COLOUR,1,0xFFF);
			break;
		// Colours REGION 3 and sets off REGION 6.
		case 3 :
			XGpio_DiscreteWrite(&REGION_3_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_6_COLOUR,1,0xFFF);
			break;
		// Colours REGION 0 and sets off REGION 3.
		case 0 :
			XGpio_DiscreteWrite(&REGION_0_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_3_COLOUR,1,0xFFF);
			break;
		}

		// Moves the current region of obstacle 2 (row 2 obstacle) to move left, if called by RNG.
		Obstacle2(&Player, &Obs2);
		switch(Obs2.currentRegion) {
		// Colours REGION 10.
		case 10 :
			XGpio_DiscreteWrite(&REGION_10_COLOUR,1,0x0F0);
			break;
		// Colours REGION 7 and sets off REGION 10.
		case 7 :
			XGpio_DiscreteWrite(&REGION_7_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_10_COLOUR,1,0xFFF);
			break;
		// Colours REGION 4 and sets off REGION 7.
		case 4 :
			XGpio_DiscreteWrite(&REGION_4_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_7_COLOUR,1,0xFFF);
			break;
		// Colours REGION 1 and sets off REGION 4.
		case 1 :
			XGpio_DiscreteWrite(&REGION_1_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_4_COLOUR,1,0xFFF);
			break;
		}

		// Moves the current region of obstacle 3 (row 3 obstacle) to move left, if called by RNG.
		Obstacle3(&Player, &Obs3);
		switch(Obs3.currentRegion) {
		// Colours REGION 11.
		case 11 :
			XGpio_DiscreteWrite(&REGION_11_COLOUR,1,0x0F0);
			break;
		// Colours REGION 8 and sets off REGION 11.
		case 8 :
			XGpio_DiscreteWrite(&REGION_8_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_11_COLOUR,1,0xFFF);
			break;
		// Colours REGION 5 and sets off REGION 8.
		case 5 :
			XGpio_DiscreteWrite(&REGION_5_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_8_COLOUR,1,0xFFF);
			break;
		// Colours REGION 2 and sets off REGION 5.
		case 2 :
			XGpio_DiscreteWrite(&REGION_2_COLOUR,1,0x0F0);
			XGpio_DiscreteWrite(&REGION_5_COLOUR,1,0xFFF);
			break;
		}
	}
	/* This state is triggered when collision occurs. Essential steps are executed here:
	 * Step 1: void EndGame() function is called, which changes colour of the users box and creates a still frame.
	 * Step 2: Makes LED start flashing, until next step occurs.
	 * Step 3: Checks if both player 1 and 2 have played, otherwise waits for last player to start playing.
	 */
	else if(i == 3) {
		// The void EndGame() function, changes colour of user and makes still frame.
		EndGame(&Player, &Obs1, &Obs2, &Obs3);

		// Flashes LED indicating game over.
		RedemptionLED();

		// Checking if 2nd player has started playing, triggered by pressing LEFT push button.
		pushBtnRight = XGpio_DiscreteRead(&P_BTN_RIGHT,1);
		i = ((slideSwitchIn >= 0x8000) && (pushBtnRight == 1)) ? 2 : i;

		gen_timer = 0;
		timer_a = 0;
		timer_b = 0;
		timer_c = 0;
		statusObs1 = 0;
		statusObs2 = 0;
		statusObs3 = 0;
		Obs1.currentRegion = 12;
		Obs2.currentRegion = 12;
		Obs3.currentRegion = 12;
		// If the 2nd player does start playing, the game refreshes itself.
		if(i == 2){
			// Resets all the initial parameters.
			Player.pointScored = 0;
			Player.currentRegion = 0;
			Player.currentColour = 0xFF0;
			GarbageCollection();
		}
	}
	else if(i == 4) {
		// The void EndGame() function, changes colour of user and makes still frame.
		EndGame(&Player, &Obs1, &Obs2, &Obs3);

		//Displaying the score of both players side by side.
		Player.pointScored = 100*Player.highScore1 + Player.highScore2;

		/* Flashing LED of the winner players side. The procedure to this is:
		 * Step 1: Start a timer (flash_timer defined globally).
		 * Step 2: Check which player won -> only illuminate that players LED.
		 * Step 3: If timer is some number (in this case 50), equate j to 0 or 1 alternatively.
		 * Step 4: If j is 1 turn LED on, else turn it off (AKA flashing).
		 */
		flash_timer = flash_timer + 1;
		// Flash LED for player 1's side.
		if(Player.highScore1 > Player.highScore2) {
			if(flash_timer == 50) {
				flash_timer = 0;
				j = (j == 0) ? 1 : 0;
				ledValue = (j == 1) ? 0xFF00 : 0x0000;
			}
		}
		// Flash LED for player 2's side.
		else {
			if(flash_timer == 50) {
				flash_timer = 0;
				j = (j == 0) ? 1 : 0;
				ledValue = (j == 1) ? 0x00FF : 0x0000;
			}
		}
		XGpio_DiscreteWrite(&LED_OUT,1,ledValue);;
	}
}

/* This function generates a random number from 0 to 4, thus modulo 5.
 * Depending on RNG number, turn the corresponding row of obstacle on.
 * 0 : First row obstacle is triggered to move left.
 * 1 : Second row obstacle is triggered to move left.
 * 2 : Third row obstacle is triggered to move left.
 */
void Generator() {
	// Declaring all local variables
	static int generatedNum;

	/* Starting the timer. Based on spawn_speed (command from main).
	 * The timer can be decreased to speed game (AKA increase level).
	 * spawn_speed = 5 : every 5 seconds a new obstacle is triggered to move left.
	 * spawn_speed = 4 : every 4 seconds a new obstacle is triggered to move left.
	 * ... and so on.
	 */
	if(gen_timer == 0) {
		generatedNum = (rand() % 3);
	}
	// Depending on generated number, trigger obstacle from corresponding row.
	switch(generatedNum) {
	case 0 :
		statusObs1 = 1;
		break;
	case 1 :
		statusObs2 = 1;
		break;
	case 2 :
		statusObs3 = 1;
		break;
	}
	gen_timer = (gen_timer < spawn_speed*100) ? gen_timer + 1 : 0;		// 2 represents 2 seconds, as 250 means 1 second.
}

/* This function is used to move the obstacles to left. The procedure do this is:
 * Step 1: If triggered by void Generator() function start process.
 * Step 2: Based on a timer, every specified time instance, the region is moved left -> subtract region by 3.
 * Step 3: Set currentRegion of obstacle to the next one decided by step 2.
 */
void Obstacle1(struct Object *Player, struct Obstacle *Obs) {
	static int counter = 0;

	counter = ((*Obs).currentRegion == 12) ? 0 : counter;
	statusObs1 = (((*Obs).currentRegion == (*Obs).startRegion - 9) && (timer_a == 0)) ? 0 : statusObs1;
	if(statusObs1 == 1) {
		// Based on movement speed, which decreases as player level, the obstacle region is moved by left once.
		if(timer_a == 0) {
			// If the obstacle reaches the left most region, player receives a point.
			(*Obs).currentRegion = (*Obs).startRegion - 3*counter;
			(*Obs).currentRegion = ((*Obs).currentRegion < 0) ? 12 : (*Obs).currentRegion;
			(*Player).pointScored = (((*Obs).currentRegion == (*Obs).startRegion - 9) && ((*Obs).currentRegion != (*Player).currentRegion)) ? (*Player).pointScored + 1 : (*Player).pointScored;
			// Start counter.
			counter++;
		}
		timer_a = (timer_a < movement_speed*50 - 1) ? timer_a + 1 : 0;		// 1 represents 0.5 seconds, as 250 means 1 second.
	}
	else {
		(*Obs).currentRegion = 12;
		counter = (counter == 4) ? 0 : counter;
	}
}

// The same procedure as void Obstacle1(), but for the second rows obstacle.
void Obstacle2(struct Object *Player, struct Obstacle *Obs) {
	static int counter = 0;

	counter = ((*Obs).currentRegion == 12) ? 0 : counter;
	statusObs2 = (((*Obs).currentRegion == (*Obs).startRegion - 9) && (timer_b == 0)) ? 0 : statusObs2;
	if(statusObs2 == 1) {
		if(timer_b == 0) {
			(*Obs).currentRegion = (*Obs).startRegion - 3*counter;
			(*Obs).currentRegion = ((*Obs).currentRegion < 0) ? 12 : (*Obs).currentRegion;
			(*Player).pointScored = (((*Obs).currentRegion == (*Obs).startRegion - 9) && ((*Obs).currentRegion != (*Player).currentRegion)) ? (*Player).pointScored + 1 : (*Player).pointScored;
			counter++;
		}
		timer_b = (timer_b < movement_speed*50 - 1) ? timer_b + 1 : 0;		// 1 represents 0.5 seconds, as 250 means 1 second.
	}
	else {
		(*Obs).currentRegion = 12;
		counter = (counter == 4) ? 0 : counter;
	}
}

// The same procedure as void Obstacle1(), but for the third rows obstacle.
void Obstacle3(struct Object *Player, struct Obstacle *Obs) {
	static int counter = 0;

	counter = ((*Obs).currentRegion == 12) ? 0 : counter;
	statusObs3 = (((*Obs).currentRegion == (*Obs).startRegion - 9) && (timer_c == 0)) ? 0 : statusObs3;
	if(statusObs3 == 1) {
		if(timer_c == 0) {
			(*Obs).currentRegion = (*Obs).startRegion - 3*counter;
			(*Obs).currentRegion = ((*Obs).currentRegion < 0) ? 12 : (*Obs).currentRegion;
			(*Player).pointScored = (((*Obs).currentRegion == (*Obs).startRegion - 9) && ((*Obs).currentRegion != (*Player).currentRegion)) ? (*Player).pointScored + 1 : (*Player).pointScored;
			counter++;
		}
		timer_c = (timer_c < movement_speed*50 - 1) ? timer_c + 1 : 0;		// 1 represents 0.5 seconds, as 250 means 1 second.
	}
	else {
		(*Obs).currentRegion = 12;
		counter = (counter == 4) ? 0 : counter;
	}
}

// This function is used to change the colour of player box to red, if collided with obstacle.
void EndGame(struct Object *Player, struct Obstacle *Obs1, struct Obstacle *Obs2, struct Obstacle *Obs3) {
	// If player is in REGION 0: change colour to red and the box to the right in REGION3 to green.
	if((*Player).currentRegion == 0 && (*Obs1).currentRegion == 0) {
		XGpio_DiscreteWrite(&REGION_0_COLOUR, 1, (*Player).currentColour);
		XGpio_DiscreteWrite(&REGION_3_COLOUR,1,0x0F0);
		//Turn all other REGIONs in the first column OFF.
		XGpio_DiscreteWrite(&REGION_1_COLOUR,1,0xFFF);
		XGpio_DiscreteWrite(&REGION_2_COLOUR,1,0xFFF);
	}
	// If player is in REGION 1: change colour to red and the box to the right in REGION4 to green.
	else if((*Player).currentRegion == 1 && (*Obs2).currentRegion == 1) {
		XGpio_DiscreteWrite(&REGION_1_COLOUR,1, (*Player).currentColour);
		XGpio_DiscreteWrite(&REGION_4_COLOUR,1,0x0F0);
		//Turn all other REGIONs in the first column OFF.
		XGpio_DiscreteWrite(&REGION_0_COLOUR,1,0xFFF);
		XGpio_DiscreteWrite(&REGION_2_COLOUR,1,0xFFF);
	}
	// If player is in REGION 2: change colour to red and the box to the right in REGION5 to green.
	else if((*Player).currentRegion == 2 && (*Obs3).currentRegion == 2) {
		XGpio_DiscreteWrite(&REGION_2_COLOUR,1, (*Player).currentColour);
		XGpio_DiscreteWrite(&REGION_5_COLOUR,1,0x0F0);
		//Turn all other REGIONs in the first column OFF.
		XGpio_DiscreteWrite(&REGION_0_COLOUR,1,0xFFF);
		XGpio_DiscreteWrite(&REGION_1_COLOUR,1,0xFFF);
	}
}

// This function turns all of the 12 REGIONs on screen off.
void GarbageCollection() {
	XGpio_DiscreteWrite(&REGION_11_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_10_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_9_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_8_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_7_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_6_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_5_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_4_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_3_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_2_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_1_COLOUR,1, 0xFFF);
	XGpio_DiscreteWrite(&REGION_0_COLOUR,1, 0xFFF);
}

/* This function allows all of the LEDs to flash. The procedure to this is:
 * Step 1: Start a timer (timer defined locally).
 * Step 2: If timer is some number (in this case 50), equate k to 0 or 1 alternatively.
 * Step 3: If k is 1 turn LED on, else turn it off (AKA flashing).
 */
void RedemptionLED() {
	static int k = 0, timer = 0;
	timer = (timer < 50) ? timer + 1 : 0;
	if(timer == 50) {
		k = (k == 0) ? 1 : 0;
		if(k == 1)
			XGpio_DiscreteWrite(&LED_OUT,1,0xFFFF);
		else{
			XGpio_DiscreteWrite(&LED_OUT,1,0x0000);
		}
		timer = 0;
	}
}