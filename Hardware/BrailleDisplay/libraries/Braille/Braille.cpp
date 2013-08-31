/*
  Braille - Library for driving stepper motors to display braille
  Copyright (c) 2013 Mark S. Baldwin, Carnegie Mellon University.  All right reserved.
*/

// include this library's description file
#include "Braille.h"

// include description files for other libraries used (if any)
#include "HardwareSerial.h"

// Constructor /////////////////////////////////////////////////////////////////
// Function that handles the creation and setup of instances


// Public Methods //////////////////////////////////////////////////////////////

/*
Given two chracters, determines the positions that the three cams should be
placed to display each character.
*/
StepperPosition Braille::mapCharacterToCam(int char1, int char2)
{
	//character arrays based on cam positioning.  These arrays map directly to the
	//optimized arrangement created on the pins.
	uint8_t topcam[16]    = { B0000, B0100, B1100, B1101, B0111, B1000, B1001, B1011,
						      B1010, B1110, B0110, B1111, B0010, B0001, B0101, B0011 };
	uint8_t middlecam[16] = { B1111, B1011, B0110, B1100, B0011, B0100, B0010, B0000, 
							  B1000, B1010, B1001, B0001, B1110, B1101, B0101, B0111 };
	uint8_t bottomcam[16] = { B1111, B0001, B0111, B1101, B0101, B0110, B1001, B0100, 
							  B1110, B0011, B1010, B0010, B0000, B1000, B1100, B1011 };
	
	/*
	StepperPosition is a wrapper struct that stores the positions for each cam.  There
	are 16 possibile positions for each cam.  Each position is determined by finding the pin state
	for a given character (up or down, therefore boolean), broken down by row (since each cam drives
	a single row).  Since a cam drives two unique characters, each cam must account for the state
	of four pins.  So two characters are combined into a 4byte value and mapped to the matching
	character on the cam using the cam arrays above.
	*/
	StepperPosition steps;
	//This is where the binary representation of the required characters to display is
	//built.
	uint8_t top = B0000;
	top = getTop(char1);
	top |= getTop(char2);
	//Now, check the top cam array for a match to determine the position of the cam
	for(int i=0; i<16; i++){
		if(topcam[i] == top){
			steps.topPosition = i;
			break;
		}
	}
	//Check for positioning on middle cam
	uint8_t mid = B0000;
	mid = getMiddle(char1);
	mid |= getMiddle(char2);
	//Now, check the top cam array for a match to determine the position of the cam
	for(int i=0; i<16; i++){
		if(middlecam[i] == mid){
			steps.middlePosition = i;
			break;
		}
	}
	//And finally, for positioning on the bottom cam
	uint8_t bot = B0000;
	bot = getBottom(char1);
	bot |= getBottom(char2);
	//Now, check the top cam array for a match to determine the position of the cam
	for(int i=0; i<16; i++){
		if(bottomcam[i] == bot){
			steps.bottomPosition = i;
			break;
		}
	}
	return steps;
}

// Private Methods /////////////////////////////////////////////////////////////


/*
Determines the cam alignment to use for the given character for
the top braille pins.
*/
uint8_t Braille::getTop(int ch)
{
	//This array represents the ascii values of the following characters:
	//a,b,e,h,k,l,o,r,u,v,z
	//These are the characters that are require the top left pin in braille to be raised.
	//TODO: figure out how to make this a private global variable to avoid reinit 
	//everytime method is called.
	int top_left[11] = { 97, 98, 101, 104, 107, 108, 111, 114, 117, 118, 121 }; 
	//i,j,s,t,w
	int top_right[5] = { 105, 106, 115, 116, 119 };
	//c,d,f,g,m,n,p,q,x,y
	int top_both[10] = { 99, 100, 102, 103, 109, 110, 112, 113, 120, 121 };

	uint8_t result = B0000;
	//find the character for each array
	for(int i=0; i<11; i++){
		if(top_left[i] == ch){
			result |= (1 << 3); 
			break;
		}
	}
	for(int i=0; i<5; i++){
		if(top_right[i] == ch){
			result |= (1 << 2);  //this should bit shift properly
			break;
		}
	}
	for(int i=0; i<10; i++){
		if(top_both[i] == ch){
			result |= (1 << 3);  //this should bit shift properly
			result |= (1 << 2);
			break;
		}
	}
	return result;
}

/*
Determines the cam alignment to use for the given character for
the middle braille pins.
*/
uint8_t Braille::getMiddle(int ch)
{
	//Middle Row
	//b,f,i,l,p,s,v
	int mid_left[7] = { 98, 102, 105, 108, 112, 115, 118 };
	//d,e,n,o,y,z
	int mid_right[6] = { 100, 101, 110, 111, 121, 122 };
	//g,h,j,q,r,t,w
	int mid_both[7] = { 103, 104, 106, 113, 114, 116, 119 };
	
	uint8_t result = B0000;
	//find the character for each array
	for(int i=0; i<7; i++){
		if(mid_left[i] == ch){
			result |= (1 << 3); 
			break;
		}
	}
	for(int i=0; i<6; i++){
		if(mid_right[i] == ch){
			result |= (1 << 2); 
			break;
		}
	}
	for(int i=0; i<7; i++){
		if(mid_both[i] == ch){
			result |= (1 << 3); 
			result |= (1 << 2); 
			break;
		}
	}
	return result;
}

/*
Determines the cam alignment to use for the given character for
the bottom braille pins.
*/
uint8_t Braille::getBottom(int ch)
{
	//Bottom Row
	//k,l,m,n,o,p,q,r,s,t
	int bot_left[10] = { 107, 108, 109, 111, 112, 113, 114, 115, 116 };
	//w
	int bot_right[1] = { 119 };
	//u,v,x,y,z
	int bot_both[5] = { 117, 118, 120, 121, 122 };
	
	uint8_t result = B0000;
	//find the character for each array
	for(int i=0; i<10; i++){
		if(bot_left[i] == ch){
			result |= (1 << 3); 
			break;
		}
	}

	if(bot_right[0] == ch){
			result |= (1 << 2); 
	}
	
	for(int i=0; i<5; i++){
		if(bot_both[i] == ch){
			result |= (1 << 3); 
			result |= (1 << 2); 
			break;
		}
	}
	return result;
}



