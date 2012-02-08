#define NOTE_C4  262

int buttonPin = 2;
int ledPin = 9;
int buttonState = LOW;
int prevButtonState = LOW;

int duration = 0;
int signalDuration = 30;


void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);  
}

void loop() {
  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {  
       analogWrite(ledPin, 255);
       tone(8, NOTE_C4, 4);
       duration+=1;
  } else {
      analogWrite(ledPin, 0);
      noTone(8);
  }
  if(prevButtonState != buttonState && buttonState==LOW){
      if(duration<signalDuration){
         Serial.print(".");
      } else {
         Serial.print("-");
      }
      duration = 0;
  }
  prevButtonState = buttonState;
  delay(10);
}
