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
Stepper botStepper(stepsPerRevolution, 44,39,16,11);   
Stepper midStepper(stepsPerRevolution, 42,38,14,9); 
Stepper topStepper(stepsPerRevolution, 40,18,12,8);     
//bottom row           
Stepper lowBotStepper(stepsPerRevolution, 25,24,23,22);          
Stepper lowMidStepper(stepsPerRevolution, 1,2,3,4);          
Stepper lowTopStepper(stepsPerRevolution, 20,21,5,6); 

int botLoc = 0;
int midLoc = 0;
int topLoc = 0;

unsigned int packetTotal = 0;
// RawHID packets should be 64 bytes
byte buffer[64];

// set pin numbers:
const int buttonPin = 26;     // the number of the pushbutton pin
const int ledPin =  6;      // the number of the LED pin

// variables will change:
int buttonState = 0;         // variable for reading the pushbutton status

void setup() {
  // set the speed of stepper motors to 60 rpm:
  botStepper.setSpeed(80);
  midStepper.setSpeed(80);
  topStepper.setSpeed(80);
  
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);   
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

void loop(){
  //uncomment to use USB to feed data to braille display
  //readHid();
  
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed.
  // if it is, the buttonState is HIGH:
  if (buttonState == HIGH) {     
    // turn LED on:    
    digitalWrite(ledPin, HIGH);  
    //sendEvent();
  } 
  else {
    // turn LED off:
    digitalWrite(ledPin, LOW); 
  }
  /* touch slider 
  int vdd = 1023;
  int slide = analogRead(A0) - analogRead(A1);
  Serial.println(slide);
  delay(25);
  */
}

//use this to show action on the microcontroller.  Just flashes the onboard led.
void flashLED(){
    digitalWrite(ledPin, HIGH); 
    delay(250);
    digitalWrite(ledPin, LOW); 
}

//displays the specified character according to braille character/motor mapping
//TODO: finish mapping.
void displayCharacter(int chr){
  Serial.print("Displaying Character: ");
  Serial.println(chr);
  int char1 = 97; //a
  int char2 = 98; //b
  
  StepperPosition result = braille.mapCharacterToCam(char1, char2);
  changeLetter(result);
}

//changes the stepper position according to the array specified in the mapping.
//TODO: add support for 6 motors.
void changeLetter(StepperPosition pos){
  Serial.println("Setting Character");
  botStepper.step(12.5*pos.bottomPosition-botLoc);
  botLoc += pos.bottomPosition-botLoc;
  midStepper.step(12.5*pos.middlePosition-midLoc);
  midLoc += pos.middlePosition-midLoc;
  topStepper.step(12.5*pos.topPosition-topLoc);
  topLoc += pos.topPosition-topLoc;
  Serial.print(botLoc);
     Serial.print("  ");
  Serial.print(midLoc);
     Serial.print("  ");
  Serial.print(topLoc);
  Serial.println();
}

//Sends the steppers back to 0 position
void resetSteppers(){
  Serial.println("Resetting");
  botStepper.step(-(12.5*botLoc));
  midStepper.step(-(12.5*midLoc));
  topStepper.step(-(12.5*topLoc));
  botLoc,midLoc,topLoc = 0;
}

//maps a character to braille, not finished.
int characterMapper(char c){
  return 0;
}

//read the USB stream using the RawHID library.
void readHid(){
 int result, index;
  index = 0;
 result = RawHID.recv(buffer, 0);
 if(result > 0){
   //changeLetter();
   //check for message type
   // 1 = braille display
   if(buffer[0] == 1){
     //join characters for 2char display
     int m = (buffer[1] * 100) + buffer[2];
     displayCharacter(m);
   }else if(buffer[0] == 2){
      resetSteppers(); 
   }
 }
}

//sends data back to USB host using the RawHID library.
void sendEvent(){
  int result;
  int index = 2;
  boolean reading = false;
  //if starts with 255/ then open, otherwise it is a remove
  //use button to toggle 
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

