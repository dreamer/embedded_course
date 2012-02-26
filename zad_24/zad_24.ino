/*
4 do H62
5 do B57
6 do H44
7 do J48



*/


#include <TinkerKit.h>

#define LEFT (4)
#define TOP (1)
#define RIGHT (2)
#define DOWN (3)
#define INVALID (0)
#define direction int
#define BUFOR (64)
int ledPinTop = 4;
int ledPinRight = 5;
int ledPinDown = 6;
int ledPinLeft = 7;

TKJoystick joystick(I0, I1);  // creating the object 'joystick' that belongs to the 'TKJoystick' class
                              // and giving the values to the desired input pins

TKLed xLed(O0), yLed(O1);     // creating the objects 'xLed' & 'yLed' that both belongs to the 'TKLed' class
                              // and giving the values to the desired output pins

int xAxisValue = 0;           // value read from the Joystick's x-axis
int yAxisValue = 0;           // value read from the Joystick's y-axis
int pos = 0;
int d = 0;
int czyZgadniete = 0;
int punkty = 1000;
int wszystkiePunkty = -1000;
int kara = 10;
void setup()
{
  Serial.begin(9600);
  pinMode(ledPinTop, OUTPUT);
  pinMode(ledPinRight, OUTPUT);
  pinMode(ledPinDown, OUTPUT);
  pinMode(ledPinLeft, OUTPUT);
}

direction getJoystickPosition(int x, int y){
  //Serial.print(x);
  //Serial.println(y);
   x = x/330;
   y = y/330;
   
   if(x==1 && y==0) return LEFT;
   if(x==2 && y==1) return DOWN;
   if(x==1 && y==2) return RIGHT;
   if(x==0 && y==1) return TOP;
   return INVALID;
   
}

void gas(){
  analogWrite(ledPinTop, 0);
  analogWrite(ledPinRight, 0);
  analogWrite(ledPinDown, 0);
  analogWrite(ledPinLeft, 0);
  delay(1000);
}

direction dir = INVALID;
int x;
int stan=1;
int ktoraRunda=0;

int getnum(){
  char *l;
  l=(char*)malloc(BUFOR);
  memset(l,0,BUFOR);
  Serial.readBytesUntil('\n',l,BUFOR);
  int ret = atoi(l);
  free(l);
  return ret;
}

void loop()
{ 
  if(stan==1){
    Serial.println("Podaj liczbe zgadniec:");
    stan=2;
  }
  if(stan==2){
    if(Serial.available()>0){
      x=getnum();
      stan=3;
    }
  }
  if(stan==3){
    xAxisValue = joystick.getXAxis();  
    yAxisValue = joystick.getYAxis();
  
  
    xLed.brightness(xAxisValue);
    yLed.brightness(yAxisValue);
  
    dir = getJoystickPosition(xAxisValue, yAxisValue);
    
    if(dir==d){
       czyZgadniete = 1;  
    }
    if(czyZgadniete){
      gas();
      ktoraRunda += 1;
      d = random(1,5); 
      analogWrite(d+3, 255);
      czyZgadniete = 0;
      wszystkiePunkty += punkty;
      Serial.print("Twoje punkty: ");
      Serial.println(wszystkiePunkty);
      punkty = 1000;
    } else {
      punkty -= kara; 
    }
    if(ktoraRunda>x){
      stan=4;
    }
  }
  if(stan==4){gas();}
  delay(10); 
}
  Serial.begin(9600);
  pinMode(ledPinTop, OUTPUT);
  pinMode(ledPinRight, OUTPUT);
  pinMode(ledPinDown, OUTPUT);
  pinMode(ledPinLeft, OUTPUT);
}

direction getJoystickPosition(int x, int y){
  //Serial.print(x);
  //Serial.println(y);
   x = x/330;
   y = y/330;
   
   if(x==1 && y==0) return LEFT;
   if(x==2 && y==1) return DOWN;
   if(x==1 && y==2) return RIGHT;
   if(x==0 && y==1) return TOP;
   return INVALID;
   
}

void gas(){
  analogWrite(ledPinTop, 0);
  analogWrite(ledPinRight, 0);
  analogWrite(ledPinDown, 0);
  analogWrite(ledPinLeft, 0);
}

direction dir = INVALID;

void loop()
{ 
  xAxisValue = joystick.getXAxis();  
  yAxisValue = joystick.getYAxis();


  xLed.brightness(xAxisValue);
  yLed.brightness(yAxisValue);

  dir = getJoystickPosition(xAxisValue, yAxisValue);
  Serial.print("Pozycja: ");
  Serial.println(dir);
  
  if(dir==d){
     czyZgadniete = 1;  
  }
  Serial.println(punkty);
  if(czyZgadniete){
    gas();
    d = random(1,5); 
    analogWrite(d+3, 255);
    czyZgadniete = 0;
    wszystkiePunkty += punkty;
    punkty = 1000;
  } else {
    punkty -= kara; 
  }
  Serial.println();
  delay(10); 
}
