Zadanie 12
- 5V idzie do -
- GND idzie do +
- A0 idzie do F4
- 9 idzie do A9
- 2 idzie do H13

int lightPin = 0;  //define a pin for Photo resistor
int ledPin=9;     //define a pin for LED
int buttonPin = 2; 
int low = 750;
int high = 980;
int buttonState = 0;
int prevState = 1;
int buttonFlag = 0;

int map(int x){
   int ret;
   if(x>high) ret = 255;
   else if(x<low) ret = 0;
   else {
     float val = x - low;
     float range = high-low;
     ret = val/range*255.0;
   }
   //Serial.println(ret);
   //Serial.println(x);
   return ret;
}

void setup()
{
    Serial.begin(9600);
    pinMode( ledPin, OUTPUT );
    pinMode(buttonPin, INPUT);  
}

void loop()
{
    buttonState = digitalRead(buttonPin);
    if (prevState != buttonState)
    {
      prevState = buttonState;
      if (buttonState == HIGH) {  
          if(buttonFlag){
            high = analogRead(lightPin);
            Serial.println(high);
          } else {
            low = analogRead(lightPin);
            Serial.println(low);
          }
          buttonFlag = ! buttonFlag;
      }  
    }
    
    analogWrite(ledPin, map(analogRead(lightPin)));
    delay(30); 
}
