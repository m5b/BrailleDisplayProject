 
int deltaLeft = 0, deltaRight = 0;

void setup(){
 Serial.begin(9600); 
}


void loop(){
  //deltaLeft = readCapacitivePin(2) -
  int p1 = readCapacitivePin(41);
  int p2 = readCapacitivePin(43);
  /*
  Serial.print(p1);
  Serial.print(" | ");
  Serial.println(p2);
  */
  
  Serial.println(p1-p2);
  
  delay(100);
}

//converts an ardiuno digital pin to allow manipulation 
//of registers.  Digital read/writes are too slow to get an accurate
//measurement.  Then pumps the pin and takes a measurement of the time
//required and thus the amount of capacitance on the pin
int checkPinCapacitance(int arduinoPin){
  volatile uint8_t* PORT;
  volatile uint8_t* DDR; 
  volatile uint8_t* PIN;
  uint8_t pinToPort, mask;
  byte pinBitMask;
  
  //helper methods that are in pins_arduino.h
  pinToPort = digitalPinToPort(arduinoPin);
  mask = digitalPinToBitMask(arduinoPin);
  
  PIN = portInputRegister(pinToPort);
  PORT = portOutputRegister(pinToPort);
  DDR = portModeRegister(pinToPort);
  pinBitMask = digitalPinToBitMask(arduinoPin);
  
  //now perform cycle
  //set pin low
  *PORT &= ~(pinBitMask);
  *DDR |= pinBitMask;
  //wait a moment and then pull pin high
  delay(5);
  *DDR &= ~(pinBitMask);
  *PORT |= pinBitMask;
  
  //check to see if there is resistance on the pin.  By measuring the amount of time
  //it took to pull the pin high.
  int hasResistance;
  //add small delay to control sensitivity of the read.  A longer delay will require
  //higher capacitance.  1 microsecond is good for basic touch by finger.
  delayMicroseconds(1);
  
  if(*PIN & pinBitMask){
    hasResistance = 0;
  }else{
    hasResistance = 1;
  }
   return hasResistance;
}


uint8_t readCapacitivePin(int pinToMeasure) {
  // Variables used to translate from Arduino to AVR pin naming
  volatile uint8_t* port;
  volatile uint8_t* ddr;
  volatile uint8_t* pin;
  // Here we translate the input pin number from
  //  Arduino pin number to the AVR PORT, PIN, DDR,
  //  and which bit of those registers we care about.
  byte bitmask;
  port = portOutputRegister(digitalPinToPort(pinToMeasure));
  ddr = portModeRegister(digitalPinToPort(pinToMeasure));
  bitmask = digitalPinToBitMask(pinToMeasure);
  pin = portInputRegister(digitalPinToPort(pinToMeasure));
  // Discharge the pin first by setting it low and output
  *port &= ~(bitmask);
  *ddr  |= bitmask;
  delay(1);
  // Make the pin an input with the internal pull-up on
  *ddr &= ~(bitmask);
  *port |= bitmask;

  // Now see how long the pin to get pulled up. This manual unrolling of the loop
  // decreases the number of hardware cycles between each read of the pin,
  // thus increasing sensitivity.
  uint8_t cycles = 30;
       if (*pin & bitmask) { cycles =  0;}
  else if (*pin & bitmask) { cycles =  1;}
  else if (*pin & bitmask) { cycles =  2;}
  else if (*pin & bitmask) { cycles =  3;}
  else if (*pin & bitmask) { cycles =  4;}
  else if (*pin & bitmask) { cycles =  5;}
  else if (*pin & bitmask) { cycles =  6;}
  else if (*pin & bitmask) { cycles =  7;}
  else if (*pin & bitmask) { cycles =  8;}
  else if (*pin & bitmask) { cycles =  9;}
  else if (*pin & bitmask) { cycles = 10;}
  else if (*pin & bitmask) { cycles = 11;}
  else if (*pin & bitmask) { cycles = 12;}
  else if (*pin & bitmask) { cycles = 13;}
  else if (*pin & bitmask) { cycles = 14;}
  else if (*pin & bitmask) { cycles = 15;}
  else if (*pin & bitmask) { cycles = 16;}
  else if (*pin & bitmask) { cycles = 17;}
  else if (*pin & bitmask) { cycles = 18;}
  else if (*pin & bitmask) { cycles = 19;}
  else if (*pin & bitmask) { cycles = 20;}
  else if (*pin & bitmask) { cycles = 21;}
  else if (*pin & bitmask) { cycles = 22;}
  else if (*pin & bitmask) { cycles = 23;}
  else if (*pin & bitmask) { cycles = 24;}
  else if (*pin & bitmask) { cycles = 25;}
  else if (*pin & bitmask) { cycles = 26;}
  else if (*pin & bitmask) { cycles = 27;}
  else if (*pin & bitmask) { cycles = 28;}
  else if (*pin & bitmask) { cycles = 29;}

  // Discharge the pin again by setting it low and output
  //  It's important to leave the pins low if you want to 
  //  be able to touch more than 1 sensor at a time - if
  //  the sensor is left pulled high, when you touch
  //  two sensors, your body will transfer the charge between
  //  sensors.
  *port &= ~(bitmask);
  *ddr  |= bitmask;

  return cycles;
}
