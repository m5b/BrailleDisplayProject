/*

Mark S Baldwin

*/

//Pin to allow the rfid reader to be reset after a read and thus allow continuous reads.
int resetPin = 13;
int chipLED = 11;
int rotaryPinLeft = 5;
int rotaryPinRight = 6;

volatile int lastChanged = 0;
int rotaryValue = 0;

unsigned int packetTotal = 0;
// RawHID packets should be 64 bytes
byte buffer[64];

void setup() {
  //send debug info over serial and prep Serial1 for transmitting over usb.
  Serial.begin(9600);
  Serial1.begin(9600);
  
  Serial.println("Setup");
  
  pinMode(resetPin, OUTPUT);
  pinMode(rotaryPinLeft, INPUT);
  pinMode(rotaryPinRight, INPUT);
  //set onboard led to flash when reading
  pinMode(chipLED, OUTPUT);
  
  digitalWrite(resetPin, HIGH);  
  digitalWrite(rotaryPinLeft, HIGH);  
  digitalWrite(rotaryPinRight, HIGH);
  
  //use interrupts to detect when a change occurs on pins, i.e. the encoder is turned.
  //use the encoder change to turn on the read loop on rfid chip.
  attachInterrupt(0, notifyChange, CHANGE);
  attachInterrupt(1, notifyChange, CHANGE);
}

void notifyChange(){
  int leftpin = digitalRead(rotaryPinLeft);
  int rightpin = digitalRead(rotaryPinRight);
  
  //The following code was adapted from bildr.org
  int change = (leftpin << 1) | rightpin; //converting the 2 pin value to single number
  int sum  = (lastChanged << 2) | change; //adding it to the previous encoded value

  if(sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) rotaryValue ++;
  if(sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) rotaryValue --;

  lastChanged = change;
}

void loop(){
  Serial.println((rotaryValue - lastChanged));
  
  if((rotaryValue - lastChanged) > 50 ||
    (rotaryValue - lastChanged) > -50)
    readTag();
 
 //just slow it down to once every second...
 delay(1000);
}

void readTag(){
  int result;
  int index = 2;
  boolean reading = false;
  //if starts with 255/ then open, otherwise it is a remove
  //use button to toggle 
  buffer[0] = 255;
  buffer[1] = 255;
    
  while(Serial1.available() > 0){
    byte readByte = Serial1.read(); //read next available byte

    if(readByte == 2) reading = true; //begining of tag
    if(readByte == 3) reading = false; //end of tag

    if(reading && readByte != 2 && readByte != 10 && readByte != 13){
      //store the tag
      digitalWrite(chipLED, HIGH);
      buffer[index] = readByte;
      index ++;
    }
  }
  
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
    
  resetReader(); //eset the RFID reader
}

void resetReader(){
  digitalWrite(resetPin, LOW);
  digitalWrite(resetPin, HIGH);
  delay(150);
  digitalWrite(chipLED, LOW);
}

/* ROtary code


//these pins can not be changed 2/3 are special pins
int encoderPin1 = 0;
int encoderPin2 = 1;
int encoderSwitchPin = 4; //push button switch

volatile int lastEncoded = 0;
volatile long encoderValue = 0;

long lastencoderValue = 0;

int lastMSB = 0;
int lastLSB = 0;

void setup() {
  Serial.begin (9600);

  pinMode(encoderPin1, INPUT); 
  pinMode(encoderPin2, INPUT);

  pinMode(encoderSwitchPin, INPUT);


  digitalWrite(encoderPin1, HIGH); //turn pullup resistor on
  digitalWrite(encoderPin2, HIGH); //turn pullup resistor on

  digitalWrite(encoderSwitchPin, HIGH); //turn pullup resistor on


  //call updateEncoder() when any high/low changed seen
  //on interrupt 0 (pin 2), or interrupt 1 (pin 3) 
  attachInterrupt(0, updateEncoder, CHANGE); 
  attachInterrupt(1, updateEncoder, CHANGE);

}

void loop(){ 
  //Do stuff here
  if(digitalRead(encoderSwitchPin)){
    
  }else{
    //button is being pushed
    Serial.println("push");
  }
 
  Serial.println(encoderValue);
  //delay(1000); //just here to slow down the output, and show it will work  even during a delay
}


void updateEncoder(){
  int MSB = digitalRead(encoderPin1); //MSB = most significant bit
  int LSB = digitalRead(encoderPin2); //LSB = least significant bit

  int encoded = (MSB << 1) |LSB; //converting the 2 pin value to single number
  int sum  = (lastEncoded << 2) | encoded; //adding it to the previous encoded value

  if(sum == 0b1101 || sum == 0b0100 || sum == 0b0010 || sum == 0b1011) encoderValue ++;
  if(sum == 0b1110 || sum == 0b0111 || sum == 0b0001 || sum == 0b1000) encoderValue --;

  lastEncoded = encoded; //store this value for next time
}

*/
