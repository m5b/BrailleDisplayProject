/*
Mark S Baldwin

Hardware controller for the 3D Printed Braille Display project.
*/

#include <Stepper.h>
#include <Braille.h>

const int stepsPerRevolution = 200;  // change this to fit the number of steps per revolution

Braille braille;
              
//setup the stepper motors.  The numbers should match the pins that are assigned to the Teensy board.

//top row
Stepper upBotStepper(stepsPerRevolution, 12,13,14,15);   
Stepper upMidStepper(stepsPerRevolution, 18,19,20,21); 
Stepper upTopStepper(stepsPerRevolution, 22,23,24,25);     
//bottom row           
Stepper lowBotStepper(stepsPerRevolution, 0,1,2,3);          
Stepper lowMidStepper(stepsPerRevolution, 4,5,6,7);          
Stepper lowTopStepper(stepsPerRevolution, 8,9,10,11); 

int upBotLoc = 0;
int upMidLoc = 0;
int upTopLoc = 0;
int lowBotLoc = 0;
int lowMidLoc = 0;
int lowTopLoc = 0;

unsigned int packetTotal = 0;
// RawHID packets should be 64 bytes
byte buffer[64];

// set pin numbers:
const int buttonPin = 26;     // the number of the pushbutton pin
const int ledPin =  6;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  // set the speed of stepper motors to 80 rpm:
  upBotStepper.setSpeed(80);
  upMidStepper.setSpeed(80);
  upTopStepper.setSpeed(80);
  lowBotStepper.setSpeed(80);
  lowMidStepper.setSpeed(80);
  lowTopStepper.setSpeed(80);
  
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);   
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

void loop(){
  //To send a message over usb to the software use the USBPrint function.
  //ex.
  //USBPrint("Hello Meng, thank you for building me!");
  //uncomment to use USB to feed data to braille display
  //readHID will pull data from the USB connection with the host system.  If any data
  //has been sent it will parse and update the braille motors.
  readHid();
  
  //in order to tell readHid to send data, we need to request it first.
  //requestHid will send a command over USB to the host system to request 4 characters
  //to display.
  //this delay is in place to simulate the movement of the finger.  It should be replaced
  //with actual finger touch response logic.
  delay(3000);
  requestHid();
}

//use this to show action on the microcontroller.  Just flashes the onboard led.
void flashLED(){
    digitalWrite(ledPin, HIGH); 
    delay(250);
    digitalWrite(ledPin, LOW); 
}

//displays the specified character according to braille character/motor mapping
void displayCharacter(char chr1, char chr2, int chr3, int chr4){
  StepperPosition result = braille.mapCharacterToCam(chr1, chr2, chr3, chr4);
  String msg;
  msg = "Upper Top: ";
  msg = msg + result.upperTop;
  USBPrint(msg);
  
  msg = "Upper Mid: ";
  msg = msg + result.upperMiddle;
  USBPrint(msg);
  
  msg = "Upper Bot: ";
  msg = msg + result.upperBottom;
  USBPrint(msg);
  
  msg = "Lower Top: ";
  msg = msg + result.lowerTop;
  USBPrint(msg);
  
  msg = "Lower Mid: ";
  msg = msg + result.lowerMiddle;
  USBPrint(msg);
  
  msg = "Lower Bot: ";
  msg = msg + result.lowerBottom;
  USBPrint(msg);
  
  changeLetter(result);
}

//changes the stepper position according to the array specified in the mapping.
void changeLetter(StepperPosition pos){
  USBPrint("Updating Display.");
  
  upBotStepper.step(12.5*(pos.upperBottom - upBotLoc));
  upBotLoc = pos.upperBottom;
  
  upMidStepper.step(12.5*(pos.upperMiddle - upMidLoc));
  upMidLoc = pos.upperMiddle;
  
  upTopStepper.step(12.5*(pos.upperTop - upTopLoc));
  upTopLoc = pos.upperTop;
  
  lowBotStepper.step(12.5*(pos.lowerBottom - lowBotLoc));
  lowBotLoc = pos.lowerBottom;
  
  lowMidStepper.step(12.5*(pos.lowerMiddle - lowMidLoc));
  lowMidLoc = pos.lowerMiddle;
  
  lowTopStepper.step(12.5*(pos.lowerTop - lowTopLoc));
  lowTopLoc = pos.lowerTop;
}

//Sends the steppers back to 0 position
void resetSteppers(){
  Serial.println("Resetting");
}

void requestHid(){
  int result;
  int index = 2;
  boolean reading = false;
  //send 255 in first two bytes to request a 4 character set to be sent to the device.
  //each request will increment on the host software.
  buffer[0] = 255;
  buffer[1] = 255;
  
  // fill the rest with zeros
  for (int i=index; i<63; i++) {
    buffer[i] = 0;
  }
  //
  buffer[63] = packetTotal;
  
  result = RawHID.send(buffer, 100);
  if (result > 0) {
    packetTotal = packetTotal + 1;
  } else {
    Serial.println("send packet failed!");
  }
}

//read the USB stream using the RawHID library.
void readHid(){
 int result, index;
 byte buff[64];
 index = 0;
 result = RawHID.recv(buff, 0);
 if(result > 0){
   //check for message type
   // 1 = braille display
   if(buff[0] == 1){
     USBPrint("Characters Received."); 
     String msg = "Displaying Character: ";
     msg = msg + (int) buff[1];
     msg = msg + "-";
     msg = msg + (int) buff[2];
     msg = msg + "-";
     msg = msg + (int) buff[3];
     msg = msg + "-";
     msg = msg + (int) buff[4];
     USBPrint(msg);
     Serial.print(msg);
     displayCharacter(buff[1], buff[2], buff[3], buff[4]);
   }else if(buff[0] == 2){
      resetSteppers(); 
   }
 }
}

void USBPrint(String message){
  int result;
  //usb standard, must break up message if greater than 64
  byte bufferb[64];
  //attach the size of message to buffer for the endpoint to handle accordingly.
  buffer[0] = message.length();
  if(message.length() > 63){
    //recursively send until all bytes sent.
    String sub = message.substring(0, 63);
    sub.getBytes(bufferb,64);
    Serial.println(sub);
    for (int i=1; i<63; i++) {
      buffer[i] = bufferb[i-1];
    }
    //Send packet over usb
    result = RawHID.send(buffer, 100);
    USBPrint(message.substring(64, message.length()));
  }else{
    Serial.println(message);
    message.getBytes(bufferb,64);
    //message will fit within buffer, so just send it.
    for (int i=1; i<63; i++) {
      buffer[i] = bufferb[i-1];
    }
    //Send packet over usb
    result = RawHID.send(buffer, 100);
  }
  if (result > 0) {
    Serial.println("message sent");
  } else {
    Serial.println("send packet failed!");
  }
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
  delayMicroseconds(2);

  if(*PIN & pinBitMask){
    hasResistance = 0;
  }
  else{
    hasResistance = 1;
  }
  return hasResistance;
}

