/*
 * interface map with Processing to light up LEDs on arduino
 * Works with Processing sketch 'pdxMap'
 */

int PinHigh[] = {0,2,3,4,5,6};  //Array of pins to controll lights
int PinLow[] = {0,7,8,9,10};
int pinMappings[20][2] = {{1,1}, {2,1}, {3,1},{4,1},{5,1}, {1,2}, {2,2}, {3,2}, {4,2}, {5,2}, {1,3}, {2,3}, {3,3}, {4,3}, {5,3}, {1,4}, {2,4}, {3,4}, {4,4}, {5,4}};
int maxtime = 100;
int timeout = 0;
int currentInput=-1;


int value = 0;  // variable to keep the actual value
void setup() 
{ 
 //Initialize pins as OUTPUTS and begin serial connection
 for(int i=1; i<6 ; i++){
  pinMode(PinHigh[i], OUTPUT); 
 }
 for(int i=1; i<5; i++){
   pinMode(PinLow[i], OUTPUT);
 }
 Serial.begin(9600);
} 
 
 
/*void loop() 
{
 
  //watch the timeout timer
  timeout++;
  int input = Serial.read();  // read serial.
  Serial.println(input);
  boolean newInput = input != currentInput;
  //Turn everything off
  for(int i=1; i<6; i++){
    digitalWrite(PinHigh[i], LOW);
  }
  for(int j=1; j<5; j++){
    digitalWrite(PinLow[j], LOW);
  }
  
    //if the new input flag is true, set the currentInput to the serial input, reset the timeout
    if(newInput==true){   
      currentInput = input;
      timeout = 0;
    }
  for(int m=1; m<21; m++){
    if(m==currentInput){
      if((timeout<maxtime)){     
        turnOn(currentInput);
      }
    }else{
     turnOff(m); 
    }
  }
   //Should we get rid of this delay? Hmmmm...
   delay(100);
} */

void loop(){
//test pattern to iterate through all 20 lights.  Comment out for normal operation
  timeout++;
  for(int i=1; i <21 ; i++){
    Serial.println(i);
    Serial.println(timeout);
    if((timeout<maxtime)){     
        turnOn(i);
      }
    else{
     turnOff(i);
     timeout=0; 
    }
    delay(100);
  }
}

  

void turnOn(int i){
  int highIndex = pinMappings[i-1][0];
  int lowIndex = pinMappings[i-1][1];
  int highPin = PinHigh[highIndex];
  int lowPin = PinLow[lowIndex];
  digitalWrite(highPin,HIGH);
  digitalWrite(lowPin,HIGH); 
}

void turnOff(int i){
  int highIndex = pinMappings[i-1][0];
  int lowIndex = pinMappings[i-1][1];
  int highPin = PinHigh[highIndex];
  int lowPin = PinLow[lowIndex];
  digitalWrite(highPin,LOW);
  digitalWrite(lowPin,LOW); 
}

