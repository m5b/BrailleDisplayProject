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
StepperPosition Braille::mapCharacterToCam(int char1, int char2, int char3, int char4)
{
	//character arrays based on cam positioning.  These arrays map directly to the
	//optimized arrangement created on the pins.
	uint8_t topcam[16]    = { B0000, B0011, B0101, B0001, B0010, B1111, B0110, B1110,
						      B1010, B1011, B1001, B1000, B0111, B1101, B1100, B0100 };

	uint8_t middlecam[16] = { B0000, B0010, B0100, B0011, B1100, B0110, B1011, B1111, 
							  B0111, B0101, B1101, B1110, B0001, B1001, B1010, B1000 };
		
    uint8_t bottomcam[16] = { B0000, B0010, B1010, B0011, B1110, B0100, B1001, B0110, 
							  B0101, B1101, B0111, B0001, B1111, B1011, B1100, B1000 };
	
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
	uint8_t top1 = B00;
	top1 = getTop(char1);
	top1 |= (getTop(char2) << 2);
	steps.upperTop = matchPosition(topcam, top1);
	
    uint8_t top2 = B00;
	top2 = getTop(char3);
	top2 |= (getTop(char4) << 2);
    steps.lowerTop = matchPosition(topcam, top2);
    
    //Check for positioning on middle cam
	uint8_t mid1 = B00;
	mid1 = getMiddle(char1);
	mid1 |= (getMiddle(char2) << 2);
	steps.upperMiddle = matchPosition(middlecam, mid1);

    uint8_t mid2 = B00;
	mid2 = getMiddle(char3);
	mid2 |= (getMiddle(char4) << 2);	
    steps.lowerMiddle = matchPosition(middlecam, mid2);
    
    //And finally, for positioning on the bottom cam
	uint8_t bot1 = B00;
    bot1 = getBottom(char1);
	bot1 |= (getBottom(char2) << 2);
	steps.upperBottom = matchPosition(bottomcam, bot1);
    
    uint8_t bot2 = B00;
    bot2 = getBottom(char3);
    bot2 |= (getBottom(char4) << 2);
    steps.lowerBottom = matchPosition(bottomcam, bot2);

    return steps;
}

// Private Methods /////////////////////////////////////////////////////////////

int Braille::matchPosition(uint8_t *camArr, uint8_t camPosition)
{
    int position;
    //Now, check the top cam array for a match to determine the position of the cam
	for(int i=0; i<16; i++){
		if(camArr[i] == camPosition){
	        position = i;
			break;
		}
	}
    return position;
}

/*
Determines the cam alignment to use for the given character for
the top braille pins.
*/
uint8_t Braille::getTop(int ch)
{
	//This array represents the ascii values of the following characters:
	//a,b,e,h,k,l,o,r,u,v,z
	//These are the characters that are require the top left pin in braille to be raised.
	int top_left[11] = { 97, 98, 101, 104, 107, 108, 111, 114, 117, 118, 121 }; 
	//i,j,s,t,w
	int top_right[5] = { 105, 106, 115, 116, 119 };
	//c,d,f,g,m,n,p,q,x,y
	int top_both[10] = { 99, 100, 102, 103, 109, 110, 112, 113, 120, 121 };

	uint8_t result = B00;
	//find the character for each array
	for(int i=0; i<11; i++){
		if(top_left[i] == ch){
			result |= (1 << 1); 
			break;
		}
	}
	for(int i=0; i<5; i++){
		if(top_right[i] == ch){
			result |= (1 << 0);  //this should bit shift properly
			break;
		}
	}
	for(int i=0; i<10; i++){
		if(top_both[i] == ch){
			result |= (1 << 1);  //this should bit shift properly
			result |= (1 << 0);
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
	
	uint8_t result = B00;
	//find the character for each array
	for(int i=0; i<7; i++){
		if(mid_left[i] == ch){
			result |= (1 << 1); 
			break;
		}
	}
	for(int i=0; i<6; i++){
		if(mid_right[i] == ch){
			result |= (1 << 0); 
			break;
		}
	}
	for(int i=0; i<7; i++){
		if(mid_both[i] == ch){
			result |= (1 << 1); 
			result |= (1 << 0); 
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
	int bot_left[10] = { 107, 108, 109, 110, 111, 112, 113, 114, 115, 116 };
	//w
	int bot_right[1] = { 119 };
	//u,v,x,y,z
	int bot_both[5] = { 117, 118, 120, 121, 122 };
	
	uint8_t result = B00;
	//find the character for each array
	for(int i=0; i<10; i++){
		if(bot_left[i] == ch){
			result |= (1 << 1); 
			break;
		}
	}

	if(bot_right[0] == ch){
			result |= (1 << 0); 
	}
	
	for(int i=0; i<5; i++){
		if(bot_both[i] == ch){
			result |= (1 << 1); 
			result |= (1 << 0); 
			break;
		}
	}
	return result;
}



