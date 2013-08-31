/*
  Braille - Library for driving stepper motors to display braille
  Copyright (c) 2013 Mark S. Baldwin, Carnegie Mellon University.  All right reserved.
*/

// ensure this library description is only included once
#ifndef Braille_h
#define Braille_h

#include "WProgram.h"

struct StepperPosition{
	int topPosition;
	int middlePosition;
	int bottomPosition;
};
// library interface description
class Braille
{
  // user-accessible "public" interface
  public:
	StepperPosition mapCharacterToCam(int char1, int char2);
  // library-accessible "private" interface
  private:
	uint8_t getTop(int ch);
	uint8_t getMiddle(int ch);
	uint8_t getBottom(int ch);
    void doSomethingSecret(void);
};

#endif

